# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: 'sample#index'
  get '/status', to: 'status#index'
  post '/status/toggle', to: 'status#update'
end
