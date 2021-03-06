class User < ActiveRecord::Base

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :password, :password_confirmation
  attr_accessible :first_name, :last_name, :handle, :email, :admin, :password, :password_confirmation

  validates :first_name, :presence => true,
                         :length => {:maximum => 50}
  validates :last_name, :presence => true,
                        :length => {:maximum => 50}
  validates :handle, :presence => true,
                     :length => {:maximum => 50},
                     :uniqueness => {:case_sensitive=>false}
  validates :email, :presence => true,
                    :format => {:with => email_regex},
                    :uniqueness => {:case_sensitive=>false}

  before_create :encrypt_password
  before_update :check_for_new_password

  belongs_to :client
  has_many   :offers
  has_many   :bids

  # Attempts to match handle to either name or email.
  # If finds a match, verifies password and
  # returns user or nil.
  def self.authenticate( handle, password )
    if user = User.find_by_handle(handle)
      return user if user.has_password?(password)
    end
    if user = User.find_by_email(handle)
      return user if user.has_password?(password)
    end
    return nil
  end

  def self.authenticate_with_salt( id, salt )
    user = User.find_by_id(id)
    ( user && user.password_salt == salt ) ? user : nil
  end

  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  def holds_debt_of? ( client_id )
    Matching.where( "payee_client_id = ? and payer_client_id = ?",
      self.client_id, client_id ) != nil
  end

#   def can_accept_bids?
#     return self.accept_bids
#   end
#
#   def can_make_bids?
#     return self.make_bids
#     true
#   end
#
#   def can_accept_offers?
#     return self.accept_offers
#   end
#
#   def can_make_offers?
#     return self.make_offers
#   end

private

  def encrypt_password
    if valid_password?
      self.password_salt = make_salt if new_record?
      self.encrypted_password = encrypt(self.password)
    else
      false
    end
  end

  def check_for_new_password
    encrypt_password if self.password and self.password.length > 0
  end

  def valid_password?
    if self.password.length < 5
      errors.add( :password, "must be six chars or more" )
    end
    if self.password != self.password_confirmation
      errors.add( :password, "must match confirmation" )
    end
    return false if errors.any?
    return true
  end

  def encrypt(pwd)
    Digest::SHA2.hexdigest( "#{self.password_salt}--#{pwd}")
  end

  def make_salt
    Digest::SHA2.hexdigest( "#{Time.now.utc}--#{self.password}")
  end
end
