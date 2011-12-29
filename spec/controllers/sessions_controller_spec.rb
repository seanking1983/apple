require 'spec_helper'

describe SessionsController do
  render_views
  
    
    # new/signin form

    it "should be successful" do
      get :new
      response.should be_success
    end
  
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign In")
    end
    
    
    # create/signin
    describe "signin failure" do
      before(:each) do
        @attr = {:email => "", :password => ""}
      end

      it "should render the new page if failed" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have an error message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end
    
    
  

end
