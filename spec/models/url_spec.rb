# spec/models/url_spec.rb
require 'rails_helper'

RSpec.describe Url, type: :model do
  describe 'validations' do
    it 'is valid with a valid long_url' do
      url = build(:url, long_url: 'https://www.valid-url.com')
      expect(url).to be_valid
    end

    it 'is invalid without a long_url' do
      url = build(:url, long_url: nil)
      url.valid?
      expect(url.errors[:long_url]).to include("can't be blank")
    end

    it 'validates the format of long_url' do
      url = build(:url, long_url: 'invalid-url')
      url.valid?
      expect(url.errors[:long_url]).to include('is invalid')
    end

    it 'validates the uniqueness of short_url' do
      create(:url, short_url: 'url-shortner-abc123')
      url = build(:url, short_url: 'url-shortner-abc123')
      url.valid?
      expect(url.errors[:short_url]).to include('has already been taken')
    end

    it 'validates the uniqueness of custom_slug' do
      create(:url, custom_slug: 'mycustomslug')
      url = build(:url, custom_slug: 'mycustomslug')
      url.valid?
      expect(url.errors[:custom_slug]).to include('has already been taken')
    end
  end

  describe 'callbacks' do
    it 'generates a short_url if no custom_slug is provided' do
      url = build(:url, custom_slug: nil)
      url.valid? # triggers before_validation
      expect(url.short_url).to start_with('url-shortner-')
    end

    it 'does not generate a new short_url if custom_slug is provided' do
      url = build(:url, custom_slug: 'mycustomslug')
      url.valid? # triggers before_validation
      expect(url.short_url).to eq('mycustomslug')
    end

    it 'sets default expiration date if expired_at is nil' do
      url = build(:url, expired_at: nil)
      url.valid? # triggers before_validation
      expect(url.expired_at).to be_within(1.second).of(5.days.from_now)
    end

    it 'does not overwrite expired_at if it is already set' do
      expiration_time = 10.days.from_now
      url = build(:url, expired_at: expiration_time)
      url.valid? # triggers before_validation
      expect(url.expired_at).to eq(expiration_time)
    end
  end

  describe '#active_short_url?' do
    it 'returns true if expired_at is nil' do
      url = build(:url, expired_at: nil)
      expect(url.active_short_url?).to be(true)
    end

    it 'returns true if the current time is before expired_at' do
      url = build(:url, expired_at: 5.days.from_now)
      expect(url.active_short_url?).to be(true)
    end

    it 'returns false if the current time is after expired_at' do
      url = build(:url, expired_at: 1.day.ago)
      expect(url.active_short_url?).to be(false)
    end
  end
end
