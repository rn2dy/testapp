FactoryGirl.define do

  factory :user do
    sequence(:name) { |n| "Test User #{n}" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password 'please'
    password_confirmation 'please'
  end

  factory :topic do
    sequence(:name) { |n| "topic #{n}" }
  end

  factory :link do
    sequence(:url) { |n| "http://interesting-site-#{n}.com" }
  end

end
