require 'spec_helper'

describe UsersController do
  render_views
  
  
  # new action ******************************************************************************************************new
  describe "get new" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new
      response.should have_selector('title', :content => "Sign Up")
    end
  end
  
  
  # show action ****************************************************************************************************show
  describe "get show" do
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end
    
    # title, name and image
   it "should have the right title" do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name)
    end

    it "should have the user's name" do
      get :show, :id => @user
      response.should have_selector('h1', :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector('h1>img', :class => 'gravatar')
    end
    
    # url 
    
    it "should have the right URL" do
      get :show, :id => @user
      response.should have_selector('td>a', :content => user_path(@user),
                                            :href    => user_path(@user))
    end

  
  end
  
  # create action ***************************************************************************************************create
  
    describe "failure" do
     
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => ""}
      end
      
      it "should have the right tilte" do
        post :create, :user => @attr
        response.should have_selector('title', :content => "Sign Up")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :name => "Xun Xu", :email => "xunx@hawaii.edu", 
                  :password => "foobar", :password => "foobar"}
      end
      
      it "should create the user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have the flash message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
      
      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
    
    # edit action ****************************************************************************************************edit
    
    describe "get edit" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end
      
      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector('title', :content => "Edit")
      end
      
      it "should have a link to change the gravatar" do
        get :edit, :id => @user
        response.should have_selector('a', :href => 'http://gravatar.com/emails',
                                           :content => "change")
      end  
    end
end
