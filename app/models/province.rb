class Province < ApplicationRecord
  default_scope { order('provinces.name') }
end
