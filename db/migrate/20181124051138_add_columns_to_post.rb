class AddColumnsToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :open_range, :boolean
    add_column :posts, :like_count, :Integer
  end
end
