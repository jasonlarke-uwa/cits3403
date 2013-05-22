class AddExtensionToImages < ActiveRecord::Migration
  def change
    add_column :images, :extension, :string
  end
end
