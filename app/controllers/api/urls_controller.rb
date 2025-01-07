# frozen_string_literal: true

class Api::UrlsController < ApplicationController

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
      render json: { error: 'Could not found URL!!' }, status: :not_found
    end
  end

  def redirect_short_url
    url = Url.find_by short_url: params[:short_url]

    if url && url.active_short_url?
      url.increment(:clicks)
      redirect_to url.long_url, allow_other_host: true
    else
      render json: { error: 'Could not found URL or it being expired!!' }, status: :not_found
    end
  end

  private

  def url_params
    params.require(:url).permit(:long_url, :custom_slug)
  end
end
