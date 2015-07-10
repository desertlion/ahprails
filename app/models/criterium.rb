class Criterium < ActiveRecord::Base
  has_many :subcriteria, foreign_key: :criteria_id
end
