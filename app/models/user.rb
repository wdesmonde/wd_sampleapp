require 'digest'

# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  # from Rubular
  email_regex = /\A([^@\s]+)@((?:[a-z0-9]+\.)+[a-z]{2,})\Z/i
  # from Hartl.  this one doesn't work in Rubular.
  # email_regex = /\A[\w+\-.]+@[a-z\d\-.]\.[a-z]+\Z/i

  validates :name, 
    :presence => true,
    :length => { :maximum => 50 }
  validates :email,
    :presence => true,
    :format   => { :with => email_regex },
    # Rails infers that :uniqueness should be true
    :uniqueness => { :case_sensitive => false }
  # automatically create the virtual attribute "password confirmation"
  validates :password, 
    :presence => true,
    :confirmation => true,
    :length => { :within => 6..40 }  

  before_save :encrypt_password

  # return true if the user's password matches the submitted password
  def has_password?(submitted_password)
    # compare the encrypted password with the encrypted version of
    #    submitted_password
    encrypted_password == encrypt(submitted_password)
  end

  # this is the one Hartl has in the main part of the book
  # explictly tests for no password and having matching password
  #  case of mismatched password handled because then reach end
  #  of method, which automatically returns nil
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  # exercise from Hartl in section 7.5 to show alternatives to 
  #   authenticate method
=begin
  #  using User instead of self in the method
  def User.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end
=end

=begin
  # the authenticate method with an explicit third return
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
    return nil
  end
=end

=begin
  # the authenticate method using an if statment
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    if user.nil?
      nil
    elsif user.has_password?(submitted_password)
      user
    else
      nil
    end
  end
=end

=begin
  # the authenticate method using an if statement and an
  #   implicit return
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    if user.nil?
      nil
    elsif user.has_password?(submitted_password)
      user
    end
  end
=end

=begin
  # the authenticate method using the ternary operator
  def self.authenticate(email,submitted_password)
    user = find_by_email(email)
    user && user.has_password?(submitted_password) ? user : nil
  end
=end




  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
