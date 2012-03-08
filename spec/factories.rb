FactoryGirl.define do

  factory :user do
    sequence(:name) { |n| "Test User #{n}" }
    sequence(:email) { |n| "example#{n}@example.com" }
    password 'please'
    password_confirmation 'please'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end

  factory :topic do
    sequence(:name) { |n| "topic #{n}" }
    notes ''
  end

  factory :link do
    sequence(:url) { |n| "http://interesting-site-#{n}.com" }
  end

  factory :user_with_owned_topics, parent: :user do
    ignore do
      topic_count 1
    end
    after_create do |user, evaluator| 
      FactoryGirl.create_list(:topic, evaluator.topic_count, owner: user)   
    end
  end

  factory :topic_with_invitees, parent: :user_with_owned_topics do
    ignore do
      invitee_count 5
    end
    after_create do |user, evaluator|
      topic = user.owned_topics.first
      FactoryGirl.create_list(:user, evaluator.invitee_count, 
        shared_topics: user.owned_topics)
    end
  end

  factory :userx do
    name 'User X'
    email 'user_x@example.com'
    password 'please'
    password_confirmation 'please'
    ignore do
      topics_count 5
    end
    after_create do |user, evaluator|
      FactoryGirl.create_list(:topic, evaluator.topics_count, user: :userx)
    end
  end
end
