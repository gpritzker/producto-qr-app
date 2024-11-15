class Role < ApplicationRecord
  ROLES = %w[supervisor apoderado].freeze

  attr_accessor :user_id, :role, :company_id
end
