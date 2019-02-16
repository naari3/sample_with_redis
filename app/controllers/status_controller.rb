# frozen_string_literal: true

class StatusController < ApplicationController
  STATUS_BLUE = 'blue'
  STATUS_GREEN = 'green'
  STATUS_CACHE_KEY = 'status'

  def index
    @status = Rails.cache.fetch(STATUS_CACHE_KEY, expires_in: 1.minute) { initial_status }
  end

  def update
    current_status = Rails.cache.read(STATUS_CACHE_KEY)
    @status = Rails.cache.write(STATUS_CACHE_KEY, toggle_status(current_status))
    redirect_to status_path
  end

  def initial_status
    [STATUS_BLUE, STATUS_GREEN].sample
  end

  def toggle_status(status)
    status == STATUS_BLUE ? STATUS_GREEN : STATUS_BLUE
  end
end
