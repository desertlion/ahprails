class CreateCriteria < ActiveRecord::Migration
  def change
    create_table :criteria do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
