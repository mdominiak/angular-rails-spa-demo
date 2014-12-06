class Meal < ActiveRecord::Base
  belongs_to :user

  validates :eaten_at, :calories, presence: true
  validates :calories, numericality: { only_integer: true, greater_than: 0, less_than: 10_000 }, allow_blank: true
  validates :description, length: {maximum: 255}, allow_blank: true
end
