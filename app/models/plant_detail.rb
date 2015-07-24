class PlantDetail < ActiveRecord::Base
    belongs_to :plant, foreign_key: :plant_id
end
