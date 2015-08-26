class CreateBelajars < ActiveRecord::Migration
  def change
    create_table :belajars do |t|
      t.string :nama
      t.string :ruang

      t.timestamps null: false
    end
  end
end
