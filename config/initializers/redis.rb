# frozen_string_literal: true

redis_connection = Redis.new(
  url: ENV['REDIS_URL'],
  driver: :hiredis
)

Redis.current = redis_connection
