class InvProperty < Netadmin
  self.primary_key  = :property_id
  self.table_name   = :invent_property

  has_many :inv_property_values, foreign_key: 'property_id', dependent: :destroy
  has_many :inv_property_lists, foreign_key: 'property_id', dependent: :destroy
  has_many :inv_property_to_types, foreign_key: 'type_id', dependent: :destroy
  has_many :inv_types, through: :inv_property_to_types
end