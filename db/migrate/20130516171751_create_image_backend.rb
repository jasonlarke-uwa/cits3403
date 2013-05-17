class CreateImageBackend < ActiveRecord::Migration
  def change
	create_table(:albums) do |t|
	  t.integer :owner_id, :null => false
	  t.integer :privacy_level_id, :null => false
      t.string :title, :limit => 64
	  t.string :description, :limit => 512
	  
	  t.timestamps
    end
  
    create_table(:images) do |t|
      t.integer :album_id, :null => false
	  t.string :uniqid, :limit => 16, :null => false
	  t.string :caption, :limit => 256
	  t.integer :width
	  t.integer :height
	  t.string :mime, :limit => 32
	  
	  t.timestamps
    end
	
	create_table(:geotag_infos) do |t|
		t.integer :image_id, :null => false
		t.decimal :longitude, :precision => 9, :scale => 6
		t.decimal :latitude, :precision => 9, :scale => 6
		t.decimal :accuracy, :precision => 9, :scale => 6
		
		t.timestamps
	end
	
	create_table(:privacy_levels) do |t|
		t.string :hint, :limit => 16
		
		t.timestamps
	end
	
	# enforce the uniquity of the uniqid at a database level while simultaneously indexing it for more
	# performant lookup complexity.
	add_index :images, :uniqid, :unique => true
	
	# foreign keys where DBMS support is available (MySQL with Inno, Oracle ..etc.)
	add_foreign_key :images, :albums
	add_foreign_key :albums, :users, :source_column => :owner_id
	add_foreign_key :albums, :privacy_levels
	add_foreign_key :geotag_infos, :images
  end
end
