class AddColsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string
    add_index :users, :name
    add_column :users, :username, :string
    add_index :users, :username
    add_column :users, :image, :string
    add_column :users, :phone, :string
    add_index :users, :phone
    add_column :users, :zipcode, :string
    add_column :users, :address1, :string
    add_column :users, :address2, :string
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  end
end
