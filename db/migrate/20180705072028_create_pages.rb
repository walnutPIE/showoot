class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :name
      t.text :body

      t.timestamps
    end
    add_index :pages, :name
  end
end
