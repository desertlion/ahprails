class AddAhpToSubCriterium < ActiveRecord::Migration
  def change
    add_column :subcriteria, :ahp, :float
  end
end
