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


    # update action **************************************************************************************************update action
    
     describe "put update" do
        before(:each) do
          @user = Factory(:user)
          test_sign_in(@user)
        end

        describe "update failure" do
          before(:each) do
            @attr = { :name => "", :email => "", :password => "", :password_confirmation => ""}
          end

          it "should render the edit page upon failure" do
            put :update, :id => @user, :user => @attr
            response.should render_template('edit')
          end

          it "should have the right title" do
            put :update, :id => @user, :user => @attr
            response.should have_selector('title', :content => "Edit")
          end
        end

        describe "update success" do
          before(:each) do
            @attr = { :name => "Sean King", :email=> "example@user.com",
                      :password => "secret", :password_confirmation => "secret" }
          end

          it "should change the user's attributes upon success" do
            put :update, :id => @user, :user => @attr
            #user = assigns(:user)
            @user.reload
            @user.name.should == @attr[:name] #user.name
            @user.email.should == @attr[:email] #user.email
            #@user.encrypted_password.should == user.encrypted_password
          end

          it "should redirect to the user profile page" do
            put :update, :id => @user, :user => @attr
            response.should redirect_to(user_path(@user))
          end

          it "should have the flash message" do
            put :update, :id => @user, :user => @attr
            flash[:success].should =~ /update success/i
          end

        end

      end
      
      # before filter ****************************************************************************************before filter
      
     describe "authentication of edit action" do
          before(:each) do
            @user = Factory(:user)
          end


          # non-signed-in users cannot edit

          it "should deny edit if not signed in" do
            put :update, :id => @user
            response.should redirect_to(signin_path)
            flash[:notice].should =~ /sign in/i
          end

          it "should deny update if not signed in" do
            put :update, :id => @user, :user => {}
            response.should redirect_to(signin_path)
          end
          
          # has to be the correct signed-in user
          
           describe "signed-in users have to be right ones to edit" do
              before(:each) do
                wrong_user = Factory(:user, :email => "example@user.net")
                test_sign_in(wrong_user)
              end

                it "should require matching user to edit" do
                  get :edit, :id => @user
                  # signin as wrong user but given the correct factory user, so will mismatch
                  response.should redirect_to(root_path)
                end

                it "should require matching user to update" do
                  put :update, :id => @user, :user => {}
                  response.should redirect_to(root_path)
                end
            end
        end
        
   # index action **************************************************************************************************index action
   
   it "should deny access to non-signed-in users" do
     get :index
     response.should redirect_to(signin_path)
     flash[:notice].should =~ /sign in/i
   end
   
   describe "for signed-in users" do
     before(:each) do
       @user = Factory(:user)
       test_sign_in(@user)
       second = Factory(:user, :email => "xunx@example.com")
       third = Factory(:user, :email => "xunx@example.net")
       @users = [@user, second, third]
       30.times do
         @users << Factory(:user, :email => Factory.next(:email))
       end
       
     end
     
     it "should redirect to the index page for signed_in users" do
       get :index
       response.should be_success
     end

     it "should have the right title" do
       get :index
       response.should have_selector('title', :content => "All Users")
     end
     
     it "should show each user on index page" do
       get :index
       User.paginate(:page => 1).each do |user|
         response.should have_selector('li', :content => user.name)
       end
     end
     
     it "should paginate users" do
       get :index
       response.should have_selector('div.pagination')
       response.should have_selector('span.disabled', :content => "Previous")
       response.should have_selector('a', :href => "/users?page=2",
                                          :content => "2" )
       response.should have_selector('a', :href => "/users?page=2",
                                          :content => "Next" )
     end
   end
end
