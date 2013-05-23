class CreateRoles < ActiveRecord::Migration
  def change
    create_table(:roles) do |t|
      ## Database authenticatable
      t.string :name
	  t.timestamps
    end

    add_index :roles, :name, :unique => true
  end
end
