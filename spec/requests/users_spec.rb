require 'spec_helper'

describe "Users" do

  describe "signup" do
  
    describe "signup failure" do

      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name", :with => ""
          fill_in "Email", :with => ""
          fill_in "Password", :with => ""
          fill_in "Confirm your password", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("dev#error_explanation")
        end.should_not change(User, :count)
      end

    end

    describe "signup success" do
      
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",  :with => "Example User"
          fill_in "Email", :with => "example@example.com"
          fill_in "Password", :with => "foolishbar"
          fill_in "Confirm your password", :with => "foolishbar"
          click_button
          response.should have_selector("div.flash.success",
            :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end

    end
 
  end

  describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_index_path
      response.status.should be(200)
    end
  end
end
