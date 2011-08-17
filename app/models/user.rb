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
  attr_accessible :name, :email

  # from Rubular
  email_regex = /\A([^@\s]+)@((?:[a-z0-9]+\.)+[a-z]{2,})\Z/i
  # from Hartl.  this one doesn't work in Rubular.
  # email_regex = /\A[\w+\-.]+@[a-z\d\-.]\.[a-z]+\Z/i

  validates :name, :presence => true,
                   :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :format   => { :with => email_regex },
                    # Rails infers that :uniqueness should be true
                    :uniqueness => { :case_sensitive => false }
  
end
