class CreateUnstructuredData < ActiveRecord::Migration
  def change
    create_table :unstructured_data do |t|
      t.string :name
      t.references :subcriterium, index: true

      t.timestamps null: false
    end
    add_foreign_key :unstructured_data, :subcriteria
  end
end
