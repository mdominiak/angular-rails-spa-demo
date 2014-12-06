class AddAuthTokenToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :auth_token, :string
    add_index :users, :auth_token, unique: true
  end

  def self.down
    remove_column :users, :auth_token, :string    
  end
end
