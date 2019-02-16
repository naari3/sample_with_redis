# frozen_string_literal: true

class SampleController < ApplicationController
  def index
    @aaa = Rails.cache.fetch('aa', expires_in: 3) { Time.now.to_s }
  end
end
