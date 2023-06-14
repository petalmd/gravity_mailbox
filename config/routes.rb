# frozen_string_literal: true

GravityMailbox::Engine.routes.draw do
  get '' => 'mailbox#index'
  get 'download_eml' => 'mailbox#download_eml'
  post 'delete' => 'mailbox#delete'
  post 'delete_all' => 'mailbox#delete_all'
end
