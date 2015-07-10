class AddTipeToSubcriterium < ActiveRecord::Migration
  def change
      add_column :subcriteria, :tipe, :boolean, :default => true
  end
end
