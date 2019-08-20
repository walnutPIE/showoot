class AddCodeToCloths < ActiveRecord::Migration[5.2]
  def change
    add_column :cloths, :code, :integer
  end
end
