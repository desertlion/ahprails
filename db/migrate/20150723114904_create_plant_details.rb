class CreatePlantDetails < ActiveRecord::Migration
  def change
    create_table :plant_details do |t|
        t.references :plant
      t.string :name
      t.string :detail
      t.string :detail_type
      t.integer :detail_id

      t.timestamps null: false
    end
  end
end
