module Warehouse
  module Orders
    # Загрузить данные об ордере для редактирования
    class Edit < BaseService
      def initialize(order_id)
        @data = {}
        @order_id = order_id
      end

      def run
        load_order
        load_divisions
        load_types
        transform_to_json

        true
      rescue RuntimeError => e
        Rails.logger.error e.inspect.red
        Rails.logger.error e.backtrace[0..5].inspect

        false
      end

      protected

      def load_order
        data[:order] = Order.includes(operations: [:inv_item_to_operations, item: { inv_item: %i[model type] }]).find(@order_id)
        data[:operation] = Operation.new(operationable: data[:order], shift: 1)
      end

      def load_divisions
        data[:divisions] = Invent::WorkplaceCount.pluck(:division).sort_by(&:to_i)
      end

      # Получить список типов оборудования с их свойствами и возможными значениями.
      def load_types
        data[:eq_types] = Invent::Type.where('name != "unknown"')
      end

      def transform_to_json
        data[:order] = data[:order].as_json(
          include: {
            operations: {
              methods: :formatted_date,
              include: [
                :inv_item_to_operations,
                item: {
                  include: {
                    inv_item: {
                      include: %i[model type]
                    }
                  }
                }
              ]
            }
          }
        )

        data[:order]['operations_attributes'] = data[:order]['operations']
        data[:order].delete('operations')

        data[:order]['operations_attributes'].each do |op|
          next unless op['item'] && op['item']['inv_item']

          op['inv_item_ids'] = op['inv_item_to_operations'].map { |io| io['invent_item_id'] }
          op['inv_item'] = op['item']['inv_item']
          op['item']['inv_item']['get_item_model'] = op['item']['item_model']

          op['item'].delete('inv_item')
          op.delete('inv_item_to_operations')
        end

        data[:order]['consumer'] = data[:order]['consumer_fio']
      end
    end
  end
end
