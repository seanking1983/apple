require 'spec_helper'

describe "LayoutLinks" do
  
  # general title tests

  it "should have a home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
  
  it "should have a contact page at '/contact'" do
    get '/contact'
    response.should have_selector('title', :content => "Contact Us")
  end
  
  it "should have an about page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About Us")
  end
  
  it "should have a help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end
  
  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should have_selector('title', :content => "Sign Up")
  end
  
  
  
  # click link tests
  
  it "should have the right links on the layout" do
    visit root_path
    response.should have_selector('title', :content => "Home")
    click_link "About"
    response.should have_selector('title', :content => "About Us")
    click_link "Contact"
    response.should have_selector('title', :content => "Contact Us")
    click_link "Home"
    response.should have_selector('title', :content => "Home")
    click_link "Sign Up!"
    response.should have_selector('title', :content => "Sign Up")
    response.should have_selector('a[href="/"]>img')
  end



  # when not signed in
   it "should have a signin link" do
     visit root_path
     response.should have_selector('a', :href => signin_path, 
                                        :content => "Sign In")
   end

   describe "when signed in" do
     before(:each) do
       @user = Factory(:user)
         visit signin_path
         fill_in :email,       :with => @user.email
         fill_in :password,    :with => @user.password
         click_button
     end

     it "should have a signout link" do
       visit root_path
       response.should have_selector('a', :href => signout_path,
                                          :content => "Sign Out")
     end

     it "should have a profile link" do
       visit root_path
       response.should have_selector('a', :href => user_path(@user),
                                          :content => "Profile")
     end


   end










end
