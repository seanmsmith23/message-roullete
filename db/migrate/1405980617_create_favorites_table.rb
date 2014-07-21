class CreateFavoritesTable < ActiveRecord::Migration
  def up
    create_table :favorites do |t|
      t.integer :message_id
    end
  end

  def down
    drop_table :favorites
  end
end
