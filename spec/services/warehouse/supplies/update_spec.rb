require 'feature_helper'

module Warehouse
  module Supplies
    RSpec.describe Update, type: :model do
      let!(:user) { create(:user) }
      let!(:supply) { create(:supply) }
      subject { Update.new(user, supply.id, supply_params) }

      context 'when add a new operation' do
        let(:type) { Invent::Type.find_by(name: :printer) }
        let(:model) { type.models.last }
        let(:item_1_attr) { attributes_for(:new_item, warehouse_type: :without_invent_num, item_type: 'DVD', item_model: 'ASUS', count: 0) }
        let(:operation_1) { attributes_for(:supply_operation, item: item_1_attr, shift: 20) }
        let(:item_2_attr) { attributes_for(:new_item, invent_type_id: type.type_id, invent_model_id: model.model_id, item_type: type.short_description, item_model: model.item_model, count: 0) }
        let(:operation_2) { attributes_for(:supply_operation, item: item_2_attr, shift: 10) }
        let(:allowed_item_keys) { %i[invent_type_id invent_model_id warehouse_type item_type item_model barcode] }
        let(:supply_params) do
          edit = Edit.new(user, supply.id)
          edit.run
          # Оставляем в item только параметры, разрешенные в strong_params
          [operation_1, operation_2].each do |op|
            op[:item].keys.each { |key| op[:item].delete(key) unless allowed_item_keys.include?(key) }
          end
          edit.data[:supply]['operations_attributes'].push(operation_1, operation_2)
          edit.data[:supply].as_json
        end

        its(:run) { is_expected.to be_truthy }

        context 'and when item does not exist' do
          it 'creates operations' do
            expect { subject.run }.to change(Operation, :count).by(2)
          end

          it 'creates items' do
            expect { subject.run }.to change(Item, :count).by(2)
          end

          it 'sets into the :count attribute value specified in the associated operation' do
            subject.run
            expect(Supply.last.items.first.count).to eq operation_1[:shift]
            expect(Supply.last.items.last.count).to eq operation_2[:shift]
          end
        end

        context 'and when item already exists' do
          let!(:existing_item_1) { create(:new_item, warehouse_type: :without_invent_num, item_type: 'Мышь', item_model: 'ASUS', count: 5) }
          let!(:existing_item_2) { create(:new_item, warehouse_type: :without_invent_num, item_type: 'DVD', item_model: 'ASUS', count: 7) }

          its(:run) { is_expected.to be_truthy }

          it 'creates operations' do
            expect { subject.run }.to change(Operation, :count).by(2)
          end

          it 'creates only one item' do
            expect { subject.run }.to change(Item, :count).by(1)
          end

          it 'does not change first item' do
            expect { subject.run }.not_to change { existing_item_1.reload.count }
          end

          let(:new_operations) { Supply.last.operations.last(2) }
          it 'changes :count attribute of existing item and sets a new value for new item' do
            subject.run
            expect(new_operations.first.item.count).to eq operation_1[:shift] + existing_item_2.count
            expect(new_operations.last.item.count).to eq operation_2[:shift]
          end
        end
      end

      context 'when remove existing operation' do
        let(:supply_params) do
          edit = Edit.new(user, supply.id)
          edit.run
          edit.data[:supply]['operations_attributes'].first['_destroy'] = 1
          edit.data[:supply].as_json
        end
        let!(:destroyed_op) { Operation.first }

        its(:run) { is_expected.to be_truthy }

        it 'destroyes operation' do
          expect { subject.run }.to change(Operation, :count).by(-1)
        end

        it 'does not destroy associated item' do
          expect { subject.run }.not_to change(Item, :count)
        end

        it 'changes count of associated item' do
          expect { subject.run }.to change { Item.first.count }.by(-destroyed_op.shift)
        end

        context 'and when item was not updated' do
          before { allow_any_instance_of(Item).to receive(:save!).and_raise(ActiveRecord::RecordNotSaved) }

          its(:run) { is_expected.to be_falsey }

          it 'does not destroy operation' do
            expect { subject.run }.not_to change(Operation, :count)
          end
        end

        context 'and when operation was not destroyed' do
          before { allow_any_instance_of(Supply).to receive(:save).and_return(false) }

          its(:run) { is_expected.to be_falsey }

          it 'does not change :count attribute of item' do
            expect { subject.run }.not_to change { destroyed_op.reload.item.count }
          end
        end

        context 'and when associated item already has processing order' do
          let(:operation) { build(:order_operation, item: Item.first, shift: 12) }
          let!(:order) { create(:order, operation: :out, operations: [operation]) }
          before { Item.first.update(count_reserved: 12) }

          its(:run) { is_expected.to be_falsey }

          it 'does not destroy operation' do
            expect { subject.run }.not_to change(Operation, :count)
          end

          it 'does not change count of associated item' do
            expect { subject.run }.not_to change { destroyed_op.reload.item.count }
          end
        end
      end

      context 'when increase :shift attribute of existing operation' do
        let(:supply_params) do
          edit = Edit.new(user, supply.id)
          edit.run
          edit.data[:supply]['operations_attributes'].first['shift'] += 5
          edit.data[:supply].as_json
        end

        it 'change :shift attribute of corresponding operation' do
          expect { subject.run }.to change { Operation.first.shift }.by(5)
        end

        it 'change :count attribute of corresponding item' do
          expect { subject.run }.to change { supply.reload.items.first.count }.by(5)
        end
      end

      context 'when reduce :shift attribute of existing operation' do
        let(:supply_params) do
          edit = Edit.new(user, supply.id)
          edit.run
          edit.data[:supply]['operations_attributes'].first['shift'] -= 5
          edit.data[:supply].as_json
        end

        it 'change :shift attribute of corresponding operation' do
          expect { subject.run }.to change { Operation.first.shift }.by(-5)
        end

        it 'change :count attribute of corresponding item' do
          expect { subject.run }.to change { supply.reload.items.first.count }.by(-5)
        end

        context 'and when item already has :count_reserved attribute' do
          before { Item.first.update(count_reserved: 19) }

          its(:run) { is_expected.to be_falsey }
        end
      end
    end
  end
end