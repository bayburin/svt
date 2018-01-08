require 'rails_helper'

module Invent
  RSpec.describe Item, type: :model do
    it { is_expected.to have_one(:warehouse_item).with_foreign_key('invent_item_id').class_name('Warehouse::Item').dependent(:destroy) }
    it { is_expected.to have_many(:property_values).inverse_of(:item).dependent(:destroy).order('invent_property.property_order') }
    it { is_expected.to have_many(:standard_discrepancies).class_name('Standard::Discrepancy').dependent(:destroy) }
    it { is_expected.to have_many(:standard_logs).class_name('Standard::Log') }
    it { is_expected.to have_many(:item_to_orders).class_name('Warehouse::ItemToOrder').with_foreign_key('invent_item_id').dependent(:destroy) }
    it { is_expected.to have_many(:orders).through(:item_to_orders).class_name('Warehouse::Order') }
    it { is_expected.to belong_to(:type) }
    it { is_expected.to belong_to(:workplace) }
    it { is_expected.to belong_to(:model) }
    it { is_expected.to validate_presence_of(:invent_num) }
    it { is_expected.to delegate_method(:properties).to(:type) }
    it { is_expected.to accept_nested_attributes_for(:property_values).allow_destroy(true) }

    describe '#presence_model' do
      context 'when item_type belongs to array Type::PRESENCE_MODEL_EXCEPT' do
        Type::PRESENCE_MODEL_EXCEPT.each do |type|
          context 'and when model is set' do
            subject { build(:item, :with_property_values, item_model: 'my model', type_name: type) }

            it { is_expected.to be_valid }
          end

          context 'and when model is not set' do
            subject { build(:item, :with_property_values, model: nil, type_name: type) }

            it { is_expected.to be_valid }
          end
        end
      end

      context 'when item_type is not part of array Type::PRESENCE_MODEL_EXCEPT' do
        context 'and when model_id is set' do
          subject { build(:item, :with_property_values, type_name: :monitor) }

          it { is_expected.to be_valid }
        end

        context 'and when item_model is set' do
          subject { build(:item, :with_property_values, model: nil, item_model: 'my model', type_name: :monitor) }

          it { is_expected.to be_valid }
        end

        context 'and when model_id and item_model is not set' do
          subject { build(:item, :with_property_values, model: nil, type_name: :monitor) }

          it { is_expected.not_to be_valid }
          it 'adds :blank error to the :base key' do
            subject.valid?
            expect(subject.errors.details[:model].first).to include(error: :blank)
          end
        end
      end
    end

    describe '#set_default_model' do
      context 'when model_id.zero?' do
        let(:item) { create(:item, :with_property_values, model: nil, item_model: 'my model', type_name: :monitor) }

        it 'should set model_id to nil' do
          expect(item.model_id).to be_nil
        end
      end
    end

    describe '#check_mandatory' do
      context 'when all properties with mandatory flag are sets' do
        subject { build(:item, :with_property_values, type_name: :printer) }

        it { is_expected.to be_valid }
      end

      context 'when not all properties with mandatory flag are sets' do
        subject { build(:item, type_name: :printer) }

        it { is_expected.not_to be_valid }

        it 'includes the { base: :property_not_filled error } error for each property_value with mandatory flag' do
          subject.valid?
          subject.properties.where(mandatory: true) do |prop|
            expect(item.errors.details[:base]).to include(error: :property_not_filled, empty_field: prop.short_description)
          end
        end
      end
    end

    describe '#model_exists?' do
      context 'when model is set' do
        subject { build(:item, type_name: :monitor) }

        its(:model_exists?) { is_expected.to be_truthy }
      end

      context 'when item_model is set' do
        subject { build(:item, model: nil, item_model: 'my model', type_name: :monitor) }

        its(:model_exists?) { is_expected.to be_truthy }
      end

      context 'when model and item_model are not sets' do
        subject { build(:item, model: nil, type_name: :monitor) }

        its(:model_exists?) { is_expected.to be_falsey }
      end
    end

    describe '#get_item_model' do
      context 'when model exists' do
        subject { build(:item, type_name: :monitor) }

        it 'returns value from model.item_model' do
          expect(subject.get_item_model).to eq subject.model.item_model
        end
      end

      context 'when item_model exists' do
        subject { build(:item, type_name: :pc, model: nil, item_model: 'My model') }

        it 'returns value from item_model' do
          expect(subject.get_item_model).to eq subject.item_model
        end
      end
    end

    describe '#get_value' do
      let(:type) { :printer }
      let(:property) { Invent::Type.find_by(name: type).properties.find_by(name: :date) }
      subject { create(:item, :with_property_values, type_name: type) }

      context 'when value stored into property_value table' do
        let(:expected_value) { subject.property_values.find_by(property: property).value }

        include_examples 'for #get_value specs'
      end

      context 'when value stored into property_list table' do
        let(:property) { Invent::Type.find_by(name: type).properties.find_by(name: :connection_type) }
        let(:expected_value) { subject.property_values.find_by(property: property).property_list.short_description }

        include_examples 'for #get_value specs'
      end

      context 'when property is another type' do
        it 'raises a RuntimeError error' do
          expect { subject.get_value('another') }.to raise_error(RuntimeError, 'Неизвестный тип свойства')
        end
      end

      context 'when result array has one value' do
        it 'return only single value' do
          expect(subject.get_value(property)).to be_a(String)
        end
      end

      context 'when result does not have any value' do
        let(:property) { Invent::Type.find_by(name: :monitor).properties.find_by(name: :diagonal) }

        it 'returns nil' do
          expect(subject.get_value(property)).to be_nil
        end
      end

      context 'when result has more that one value' do
        let(:prop_val) { property.property_values.first }

        it 'returns array of values' do
          allow(subject.property_values).to receive_message_chain(:includes, :where, :find_each).and_yield(prop_val).and_yield(prop_val)
          expect(subject.get_value(property).size).to eq 2
        end
      end
    end
  end
end
