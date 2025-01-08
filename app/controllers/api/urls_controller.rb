# frozen_string_literal: true

class Api::UrlsController < ApplicationController
  skip_before_action :track_ahoy_visit, only: %i[create index show analytics redirect_short_url]
  def create
    url = Url.new(url_params)
    if url.save
      render json: { short_url: url.short_url, long_url: url.long_url }, status: :created
    else
      render json: { error: url.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    urls = Url.all
    render json: urls, status: :ok
  end

  def show
    url = Url.find_by(short_url: params[:id])
    if url
      render json: { long_url: url.long_url, short_url: url.short_url, clicks: url.clicks }, status: :ok
    else
      render json: { error: 'Could not find URL!!' }, status: :not_found
    end
  end

  def redirect_short_url
    url = Url.find_by(short_url: params[:short_url])

    if url && url.active_short_url?
      ahoy.track 'Visited shortened URL'

      url.increment(:clicks)
      url.save
      redirect_to url.long_url, allow_other_host: true
    else
      render json: { error: 'Could not find URL or it has expired!!' }, status: :not_found
    end
  end

  def analytics
    url = Url.find_by(long_url: params[:long_url])
    if url
      visits = Ahoy::Visit.where('landing_page LIKE ?', "%#{url.short_url}%")
      total_visits = visits.count
      browsers = visits.group(:browser).count
      devices = visits.group(:device_type).count
      locations = visits.group(:country).count

      render json: {
        total_visits: total_visits,
        browsers: browsers,
        devices: devices,
        locations: locations,
        visits: visits.limit(5).select(:visitor_token, :ip, :device_type, :referrer, :landing_page, :browser)
      }, status: :ok
    else
      render json: { error: 'Could not find URL!!' }, status: :not_found
    end
  end

  private

  def url_params
    params.require(:url).permit(:long_url, :custom_slug)
  end
end
