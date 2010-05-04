class UsersController < ApplicationController

  before_filter :admin_authorized?

  def index
    @users = User.paginate :page => params[:page]
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = 'User was successfully created.'
      redirect_to(@user)
    else
      flash[:error] = 'Creating user failed.'
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to(@user)
    else
      flash[:error] = 'Updating user failed.'
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = 'User destroyed successfully.'
    else
      flash[:error] = 'Deleting of user failed.'
    end
    redirect_to(users_url)
  end
end
