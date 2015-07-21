FactoryGirl.define do
  factory :link do
    sequence(:title) { |n| "Sequenced Title (#{n})" }
    sequence(:url) { |n| "http://www.#{n}example#{n}.com/#{n}" }
  end
end
