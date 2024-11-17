class Authorization < ApplicationRecord
  has_one_attached :authorization_file, service: :authorizations

  belongs_to :company
  belongs_to :user

  validates :authorization_file, 
            content_type: ['application/pdf'], 
            size: { less_than: 5.megabytes }, 
            if: -> { authorization_file,present? }
end
