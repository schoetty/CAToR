class SessionsController < ApplicationController

before_filter :authorized?, :except => [:new, :create]

  def welcome
    student = User.find_by_login(session[:login])
    @exam_allocations = ExamAllocation.find(:all, :conditions => { :student_id => student.id } )
  end

  # login
  def create
    if User.authenticate(params[:login], params[:password])
      session[:auth] = true
      session[:login] = params[:login]
      flash[:notice] = session[:login] + " logged in successfully"
      redirect_to home_path
    else
      flash[:error] = "Login not successful"
      redirect_to login_path
    end
  end

  # logout
  def destroy
    reset_session
    flash[:notice] = "Logout successful"
    redirect_to login_path
  end
end
