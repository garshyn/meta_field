class Record < ApplicationRecord

  has_meta_fields :field1
  has_meta_fields :field2, scope: :scope1

end
