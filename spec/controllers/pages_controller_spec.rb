require 'spec_helper'

describe PagesController do


# link test

    it "should be successful" do
      get :home
      response.should be_success
    end
  

    it "should be successful" do
      get :contact
      response.should be_success
    end
  

    it "should be successful" do
      get :about
      response.should be_success
    end
  

    it "should be successful" do
      get :help
      response.should be_success
    end

# title test
    
    it "should have the right title for home" do
      get :home
      response.should have_selector('title', :content => "Home")
    end

    it "should have the right title for home" do
      get :contact
      response.should have_selector('title', :content => "Contact Us")
    end
    
    it "should have the right title for home" do
      get :about
      response.should have_selector('title', :content => "About Us")
    end
    
    it "should have the right title for home" do
      get :help
      response.should have_selector('title', :content => "Help")
    end
end
