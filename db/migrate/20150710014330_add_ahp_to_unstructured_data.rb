class AddAhpToUnstructuredData < ActiveRecord::Migration
  def change
      add_column :unstructured_data, :ahp, :float
  end
end
