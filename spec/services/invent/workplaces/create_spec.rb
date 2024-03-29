require 'feature_helper'

module Invent
  module Workplaces
    RSpec.describe Create, type: :model do
      let!(:user) { create(:user) }
      let!(:workplace_count) { create(:active_workplace_count, users: [user]) }
      let(:room) { IssReferenceSite.first.iss_reference_buildings.first.iss_reference_rooms.first }
      let(:workplace_attachments) { [] }
      subject { Create.new(user, workplace, workplace_attachments) }

      context 'with valid workplace params' do
        let(:workplace) { create_workplace_attributes(true, room: room) }
        let(:prop_val_count) do
          count = 0
          workplace['items_attributes'].each { |item| count += item['property_values_attributes'].count }
          count
        end

        it 'sets location_room_id variable' do
          subject.run
          expect(subject.instance_variable_get(:@workplace_params)['location_room_id']).to eq room.room_id
        end

        it 'saves a new workplace in the database' do
          expect { subject.run }.to change(Workplace, :count).by(1)
        end

        it 'saves a new items in the database' do
          expect { subject.run }.to change(Item, :count).by(workplace['items_attributes'].count)
        end

        it 'saves a new property_values in the database' do
          expect { subject.run }.to change(PropertyValue, :count).by(prop_val_count)
        end

        it 'fills a @data at least with %w[short_description fio duty location status] keys' do
          subject.run
          expect(subject.data).to include('short_description', 'fio', 'duty', 'location', 'status')
        end

        it 'broadcasts to workplaces' do
          expect(subject).to receive(:broadcast_workplaces)
          subject.run
        end

        it 'broadcasts to workplaces_list' do
          expect(subject).to receive(:broadcast_workplaces_list)
          subject.run
        end

        it 'broadcasts to items' do
          expect(subject).to receive(:broadcast_items)
          subject.run
        end

        context 'and when have item with properties assign barcode' do
          before do
            workplace['items_attributes'].push(new_item)
            workplace['disabled_filters'] = true
          end

          include_examples 'property_value is creating'
        end

        it 'count barcode increased' do
          subject.run

          expect(Barcode.count).to eq workplace['items_attributes'].count
        end

        context 'and when add attachments' do
          let(:new_attachment) { { id: nil, workplace_id: nil } }
          let(:file) do
            Rack::Test::UploadedFile.new(Rails.root.join('spec/files/old_pc_config.txt'), 'text/plain')
          end
          let(:workplace_attachments) { [file, file] }
          before { workplace['attachments_attributes'] = [new_attachment, new_attachment] }

          it 'count of attachments has changed ' do
            expect { subject.run }.to change(Attachment, :count).by(workplace_attachments.count)
          end

          it 'assigns identifier for each file' do
            subject.run

            Attachment.all.each do |att|
              expect(att.document.file.identifier).to eq file.original_filename
            end
          end
        end

        it 'returns is blank count of attachments' do
          subject.run

          expect(Attachment.count).to be_zero
        end

        its(:run) { is_expected.to be_truthy }
      end

      context 'when add item from another workplace' do
        let!(:workplace_2) { create(:workplace_pk, :add_items, items: %i[pc monitor]) }
        let!(:workplace) do
          tmp = build(
            :workplace_pk,
            :add_items,
            items: %i[pc monitor],
            iss_reference_room: nil,
            location_room_name: room.name
          ).as_json(
            include: {
              items: {
                include: %i[
                  property_values
                  barcode_item
                ]
              }
            },
            methods: :location_room_name
          )

          tmp['items_attributes'] = tmp['items']
          tmp['items_attributes'].each do |item|
            item['property_values_attributes'] = item['property_values']
            item['barcode_item_attributes'] = item['barcode_item']

            item.delete('property_values')
            item.delete('barcode_item')
          end

          new_mon = workplace_2.items.last.as_json(include: %i[property_values barcode_item])
          new_mon['status'] = 'prepared_to_swap'
          new_mon['id'] = new_mon['item_id']
          new_mon['property_values_attributes'] = new_mon['property_values']
          new_mon['barcode_item_attributes'] = new_mon['barcode_item']

          new_mon['property_values_attributes'].each do |prop_val|
            prop_val['id'] = prop_val['property_value_id']

            prop_val.delete('property_value_id')
          end

          new_mon.delete('item_id')
          new_mon.delete('property_values')
          new_mon.delete('barcode_item')

          tmp['items_attributes'] << new_mon

          tmp.delete('items')
          tmp
        end
        let(:swap) { Warehouse::Orders::Swap.new(user, workplace_2.workplace_id + 1, [workplace['items_attributes'].last['id']]) }

        its(:run) { is_expected.to be_truthy }

        it 'runs Warehouse::Orders::Swap service' do
          expect(Warehouse::Orders::Swap).to receive(:new).with(user, workplace_2.workplace_id + 1, [workplace['items_attributes'].last['id']]).and_return(swap)
          expect(swap).to receive(:run)

          subject.run
        end

        it 'create all items of created workplace' do
          subject.run

          expect(Workplace.last.items.count).to eq 3
        end

        it 'increment count of barcode for items' do
          expect { subject.run }.to change(Barcode, :count).by(workplace_2.items.count)
        end

        it 'barcodes correspond to items' do
          subject.run

          workplace_2.items.each do |item|
            expect(item.barcode_item.codeable_type).to eq item.class.name
            expect(item.barcode_item.codeable_id).to eq item.item_id
          end
        end

        it 'reduces count of items for workplace_2' do
          expect { subject.run }.to change(workplace_2.reload.items, :count).by(-1)
        end

        it 'broadcasts to archive_orders' do
          expect(subject).to receive(:broadcast_archive_orders)
          subject.run
        end

        context 'when Warehouse::Orders::Swap service returns false' do
          before { allow_any_instance_of(Warehouse::Orders::Swap).to receive(:run).and_return(false) }

          its(:run) { is_expected.to be_falsey }

          it 'does not save workplace' do
            expect { subject.run }.not_to change(Item, :count)
          end
        end
      end

      context 'with invalid workplace params' do
        let(:workplace) { create_workplace_attributes(false) }

        its(:run) { is_expected.to be_falsey }
      end
    end
  end
end
