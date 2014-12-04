class CreateMeals < ActiveRecord::Migration
  def self.up
    create_table :meals do |t|
      t.references :user, null: false
      t.datetime :eaten_at, null: false
      t.integer :calories, null: false
      t.string :description, null: false, default: ''

      t.timestamps
    end

    add_index :meals, [:user_id, :eaten_at], order: {eaten_at: :desc}
  end

  def self.down
    drop_table(:meals)
  end
end
