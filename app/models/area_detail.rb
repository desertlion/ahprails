class AreaDetail < ActiveRecord::Base
    belongs_to :area, foreign_key: :area_id
end
