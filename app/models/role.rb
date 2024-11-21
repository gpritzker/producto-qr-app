class Role < ApplicationRecord
  belongs_to :company
  belongs_to :user

  ROL_DELEGADO = 0
  ROL_SUPERVISOR = 1
  ROL_APODERADO = 2

  enum role: {delegado: self::ROL_DELEGADO, supervisor: self::ROL_SUPERVISOR, apoderado: self::ROL_APODERADO }

  validates :company_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :company_id }

  def self.role_name(role_id)
    return  case role_id
            when 2
              "apoderado"
            when 1
              "supervisor"
            else
              "delegado"
            end
  end
end
