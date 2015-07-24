class CreateAreaDetailTable < ActiveRecord::Migration
  def change
    create_table :area_details do |t|
      t.references :area, index: true
      t.string :name
      t.string :detail
      t.string :detail_type
      t.integer :detail_id
    end
    add_foreign_key :area_detail, :areas
  end
end
