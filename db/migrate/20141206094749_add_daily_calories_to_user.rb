class AddDailyCaloriesToUser < ActiveRecord::Migration
  def change
    add_column :users, :daily_calories, :integer, default: 2000, null: false
  end
end
