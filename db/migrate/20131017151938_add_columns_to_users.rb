class AddColumnsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :provider, :string, :default => "google"
    add_column :users, :uid, :string
    add_column :users, :name, :string
  end

  def down
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :name
  end
end
