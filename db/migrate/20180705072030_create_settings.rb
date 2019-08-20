class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.string :title
      t.string :name
      t.text :body
      t.string :image
      t.string :url
      t.integer :position

      t.timestamps
    end
    add_index :settings, :name
    add_index :settings, :position
  end
end
