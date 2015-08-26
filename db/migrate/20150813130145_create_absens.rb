class CreateAbsens < ActiveRecord::Migration
  def change
    create_table :absens do |t|
      t.string :nama
      t.string :alamat
      t.integer :nim

      t.timestamps null: false
    end
  end
end
