class CreateCloths < ActiveRecord::Migration[5.2]
  def change
    create_table :cloths do |t|
      t.references :codi, foreign_key: true
      t.string :color
      t.string :main_category
      t.string :sub_category

      t.timestamps
    end
  end
end
