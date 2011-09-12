# by using the symbol ':user', we get Factory Girl to 
#  simulate the User mode
Factory.define :user do |user|
  user.name "Some Won"
  user.email "some@example.net"
  user.password "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end


