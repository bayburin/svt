require 'feature_helper'

module Invent
  module Statistics
    RSpec.describe UpsBattery, type: :model do
      let(:battery_type_prop) { Property.find_by(name: :battery_type) }
      let(:battery_count_prop) { Property.find_by(name: :battery_count) }
      let(:battery_module_prop) { Property.find_by(name: :battery_module) }
      let(:battery_replacement_date) { Property.find_by(name: :replacement_date) }
      let(:prop_lists) { battery_type_prop.property_lists }
      let(:battery_type_val) { prop_lists.first }
      let(:ups) { create_list(:item, 5, :with_property_values, type_name: 'ups', priority: :high) }
      let(:battery_count_val) { battery_count_prop.property_lists.first.value }
      let(:battery_module_val) { '4' }
      let(:total_count) { ups.inject(0) { |sum, _el| sum + battery_count_val.to_i + battery_module_val.to_i } }
      # Умножаем на 2, так как далее у двух ИБП ставим срок давности замены батарей на критическую отметку
      let(:to_replace_count) { (battery_count_val.to_i + battery_module_val.to_i) * 2 }
      before do
        ups.each_with_index do |u, index|
          u.property_values.find_by(property: battery_replacement_date).update(value: Time.zone.now - Item::LEVELS_BATTERY_REPLACEMENT[:critical].years) if [0, 1].include?(index)
          u.property_values.find_by(property: battery_type_prop).update(property_list: battery_type_val)
          u.property_values.find_by(property: battery_module_prop).update(value: battery_module_val)
        end

        subject.run
      end

      its(:run) { is_expected.to be_truthy }

      it 'returns array with %i[id value description total_count to_replace_count] keys' do
        expect(subject.data.first).to include(:id, :value, :description, :total_count, :to_replace_count)
      end

      it 'loads to array all property_lists values which belongs to :battery_type property' do
        prop_lists.each do |prop_list|
          expect(subject.data.any? { |el| el[:id] == prop_list.property_list_id }).to be_truthy
        end
      end

      it 'calculates total count of batteries for each battery type' do
        expect(subject.data.find { |el| el[:id] == battery_type_val.property_list_id }[:total_count]).to eq total_count
      end

      it 'calculates count of batteries which need to replace' do
        expect(subject.data.find { |el| el[:id] == battery_type_val.property_list_id }[:to_replace_count]).to eq to_replace_count
      end

      context 'when property_values contains is blank property_list_id' do
        let(:property) { Invent::Type.find_by(name: :ups).properties.find_by(name: :battery_type) }

        before { ups.last.property_values.find_by(property: property).update(property_list_id: nil) }

        it 'not all values ups contain the existing property_list_id' do
          expect(ups.all? { |up| subject.data.any? { |el| el[:id] == up.property_values.find_by(property: property).property_list_id } }).to be_falsey
        end
      end
    end
  end
end
