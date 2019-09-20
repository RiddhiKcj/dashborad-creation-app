FactoryBot.define do
  factory :active_api do
    name { "MyString" }
    api_url { "MyString" }
    api_key { "MyString" }
    active { false }
    user { nil }
  end
end
