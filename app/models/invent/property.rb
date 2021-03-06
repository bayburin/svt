module Invent
  class Property < BaseInvent
    self.primary_key = :property_id
    self.table_name = "#{table_name_prefix}property"

    # Свойства ПК, которые должны быть заполнены из утилиты SysConfig
    FILE_DEPENDING = %w[mb ram video cpu hdd].freeze
    # Свойства, которые не обязательны для заполнения в случае, если для текущего экземпляра техники указан инвентарный
    # номер, который встречается в модели PcException.
    PROP_MANDATORY_EXCEPT = %w[network_connection mb ram video cpu hdd].freeze
    # Свойства, обозначающие дату
    DATE_PROPS = %w[date date_month].freeze
    # Свойства, обозначающие выбор из списка
    LIST_PROPS = %w[list list_plus].freeze
    # Наименование свойств, к которым может назначаться техника со склада со штрих-кодом в property_values
    LIST_TYPE_FOR_BARCODES = Invent::Property.where(assign_barcode: true).pluck(:short_description).map(&:downcase).freeze

    has_many :property_to_types, dependent: :destroy
    has_many :types, through: :property_to_types
    has_many :property_values, dependent: :destroy
    has_many :property_lists, dependent: :destroy
    has_many :model_property_lists, dependent: :restrict_with_error
    has_many :warehause_property_values, class_name: 'Warehouse::PropertyValue', foreign_key: 'property_id', dependent: :destroy
  end
end
