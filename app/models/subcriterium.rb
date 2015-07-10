class Subcriterium < ActiveRecord::Base
    belongs_to :criterium, foreign_key: :criteria_id
    has_many :unstructured_data
end
