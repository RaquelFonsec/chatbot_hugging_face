# app/models/message.rb
class Message < ApplicationRecord
    validates :role, inclusion: { in: %w[user assistant] }
    validates :content, presence: true
  end
  