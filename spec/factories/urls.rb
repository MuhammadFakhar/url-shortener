FactoryBot.define do
  factory :url do
    long_url { 'MyText' }
    short_url { 'MyString' }
    clicks { 1 }
  end
end
