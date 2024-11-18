class AddDelegationToAuthorizations < ActiveRecord::Migration[7.0]
  def change
    add_reference :authorizations, :delegation, foreign_key: true
  end
end
