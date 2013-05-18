class CreateFriends < ActiveRecord::Migration
  def change
    create_table(:friends) do |t|
      t.integer :initiator_id
	  t.integer :recipient_id
	  t.string :confirmation, :limit => 32
	  
	  t.timestamps
    end
  end
end
