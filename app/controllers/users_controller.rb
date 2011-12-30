class UsersController < ApplicationController
  
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  
  def new
    @user = User.new
    @title = "Sign Up"
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def create
    #raise params[:user].inspect
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign Up"
      render 'new'
    end
  end
  
  def edit
    @title = "Edit User"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile update success!"
      redirect_to @user
    else
      @title = "Edit User"
      render 'edit'
    end
  end
  
  
  
  private 
  
    def authenticate
      deny_access unless signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless @user == current_user
    end
  

end
