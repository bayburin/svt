module Inventory
  module LkInvents
    class DeleteWorkplace < BaseService
      include ActiveModel::Validations

      def initialize(workplace_id)
        @workplace_id = workplace_id
      end

      def run
        @data = Workplace.find(@workplace_id)
        destroy_workplace
      rescue RuntimeError
        false
      end

      private

      def destroy_workplace
        return true if @data.destroy_from_lk
        Rails.logger.error @data.errors.full_messages.inspect.red

        errors.add(:base, @data.errors.full_messages.join(', '))
        raise 'abort'
      end
    end
  end
end