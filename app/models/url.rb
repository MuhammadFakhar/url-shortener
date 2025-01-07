class Url < ApplicationRecord

  validates :long_url, presence: true
  validates :custom_slug, uniqueness: true, allow_nil: true
  validates :short_url, uniqueness: true
  validates :long_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  before_validation :generate_short_url, on: :create
  before_validation :set_default_expiration


  def active_short_url?
    expired_at.nil? || Time.current < expired_at
  end

  private

  def generate_short_url
    prefix = 'url-shortner-'
    short_url = custom_slug.presence || (prefix + SecureRandom.urlsafe_base64(20))
    self.short_url ||= short_url
  end

  def set_default_expiration
    self.expired_at ||= 5.days.from_now
  end
end
