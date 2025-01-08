FactoryBot.define do
  factory :url do
    long_url { 'https://www.sample.com' }
    custom_slug { nil }
    expired_at { 5.days.from_now }
  end
end
