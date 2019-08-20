class CreateIntros < ActiveRecord::Migration[5.2]
  def change
    create_table :intros do |t|
      t.string :title
      t.text :body
      t.string :image
      t.integer :position

      t.timestamps
    end
    add_index :intros, :position
  end
end
