class Record < ApplicationRecord

  has_meta_fields :field1
  # has_meta_fields :field2, scope: :scope1
  # has_meta_fields :field3, :field4, scope: :scope2, prefix: true

end
