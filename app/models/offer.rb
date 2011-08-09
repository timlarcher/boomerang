class Offer < ActiveRecord::Base

  belongs_to :client
  belongs_to :user

  scope :for_client, lambda { |id| where('client_id = ?', id) }

  scope :for_user, lambda { |id| where('user_id = ?', id) }

  scope :active, where( :closed => false )

  scope :closed, where( :closed => true )

end
