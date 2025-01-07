class Url < ApplicationRecord
  validates :long_url, presence: true
  validates :short_url, uniqueness: true
  validates :long_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  before_validation :generate_short_url, on: :create

  private

  def generate_short_url
    prefix = 'url-shortner.ly/'
    short_url = prefix + SecureRandom.urlsafe_base64(20)
    self.short_url ||= short_url
  end
end
