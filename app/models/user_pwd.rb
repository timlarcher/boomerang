class User < ActiveRecord::Base

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  attr_accessor :password
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
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..40}

  before_create :encrypt_password
  before_update :check_for_new_password

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

private

  def encrypt_password
    self.password_salt = make_salt if new_record?
    self.encrypted_password = encrypt(self.password)
  end

  def check_for_new_password
    return if !self.password
    encrypt_password
  end

  def encrypt(pwd)
    Digest::SHA2.hexdigest( "#{self.password_salt}--#{pwd}")
  end

  def make_salt
    Digest::SHA2.hexdigest( "#{Time.now.utc}--#{self.password}")
  end
end
