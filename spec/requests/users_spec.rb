require 'spec_helper'

describe "Users" do
  
  
  # signup failure
    it "should not make a user" do
      lambda do
        visit signup_path
        fill_in "Name",             :with => ""
        fill_in "Email",            :with => ""
        fill_in "Password",         :with => ""
        fill_in "Retype Password",  :with => ""
        click_button
        response.should render_template('users/new')
        response.should have_selector('div#error_explanation')
      end.should_not change(User, :count)
    end
  
  
  # signup success
  
    it "should make a new user" do
      lambda do
        visit signup_path
        fill_in "Name",             :with => "Xun Xu"
        fill_in "Email",            :with => "xunx@hawaii.edu"
        fill_in "Password",         :with => "hawaii123456"
        fill_in "Retype Password",  :with => "hawaii123456"
        click_button
        response.should have_selector('div.flash.success', :content => "Welcome")
        response.should render_template('users/show')
      end.should change(User, :count).by(1)
    end
    
    
    # signin failure
      it "should not sign the user in" do
        visit signin_path
        fill_in "Email",            :with => ""
        fill_in "Password",         :with => ""
        click_button
        response.should have_selector('div.flash.error', :content => "Invalid")
        response.should render_template('sessions/new')
      end
    
    
    # signin and signout success
      it "should sign a user in and out" do
        user = Factory(:user)
        visit signin_path
        fill_in "Email",            :with => user.email
        fill_in "Password",         :with => user.password
        click_button
        controller.should be_signed_in
        click_link "Sign Out"
        controller.should_not be_signed_in
      end
    
    
end
