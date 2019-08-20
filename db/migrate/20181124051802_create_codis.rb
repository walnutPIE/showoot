class CreateCodis < ActiveRecord::Migration[5.2]
  def change
    create_table :codis do |t|
      t.references :post, foreign_key: true
      t.json :weather
      t.string :event
      t.integer :preference

      t.timestamps
    end
  end
end
