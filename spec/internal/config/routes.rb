# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'application#index'
  get 'application/index'
  post 'application/send_mail', as: :send_mail
end
