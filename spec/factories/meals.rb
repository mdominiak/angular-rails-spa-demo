FactoryGirl.define do
  factory :meal do
    sequence(:eaten_at) {|i| Time.now.change(usec: 0) - (i - 1) * 60 * 60 }
    calories { rand(1000) + 1 }
    sequence(:description) {|i| "description #{i}"}
  end
end
