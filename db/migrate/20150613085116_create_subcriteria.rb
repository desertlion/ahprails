class CreateSubcriteria < ActiveRecord::Migration
  def change
    create_table :subcriteria do |t|
      t.string :name
      t.references :criteria, index: true

      t.timestamps null: false
    end
    add_foreign_key :subcriteria, :criteria
  end
end
