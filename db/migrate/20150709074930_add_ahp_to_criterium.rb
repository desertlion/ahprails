class AddAhpToCriterium < ActiveRecord::Migration
  def change
    add_column :criteria, :ahp, :float
  end
end
