class ExamAllocationsController < ApplicationController

  before_filter :admin_authorized?, :except => [:list, :exam_list]
  before_filter :authorized?, :only => [:list, :exam_list]

  def list
    student = User.find_by_login(session[:login])
    @exam_allocations = ExamAllocation.find(:all, :conditions => { :student_id => student.id } )
  end

  def index
    @exam_allocations = ExamAllocation.paginate :page => params[:page]
  end

  def show
    @exam_allocation = ExamAllocation.find(params[:id])
  end

  def new
    @exam_allocation = ExamAllocation.new
    @categories = Category.all
    @users = User.find(:all, :conditions => {:is_admin => 'f'}) # only students - value may differ from database to database...
  end

  def edit
    @categories = Category.all
    @users = User.find(:all, :conditions => {:is_admin => 'f'})
    @exam_allocation = ExamAllocation.find(params[:id])
  end

  def create
    @categories = Category.all
    @users = User.find(:all, :conditions => {:is_admin => 'f'})
    @exam_allocation = ExamAllocation.new(params[:exam_allocation])

    unless ExamAllocation.existing?(@exam_allocation)
      if @exam_allocation.save
        flash[:notice] = 'Allocation was successfully created.'
        redirect_to exam_allocations_url
      else
        flash[:error] = 'An error occured saving the allocation.'
        render :action => "new"
      end
    else
      flash[:error] = 'This allocation already exists.'
      render :action => "new"
    end
  end

  def update
    @categories = Category.all
    @users = User.find(:all, :conditions => {:is_admin => 'f'})
    @exam_allocation = ExamAllocation.find(params[:id])

    if @exam_allocation.update_attributes(params[:exam_allocation])
      flash[:notice] = 'Exam Allocation updated successfully.'

      redirect_to(@exam_allocation)
    else
      render :action => "edit"
    end
  end

  def destroy
    @exam_allocation = ExamAllocation.find(params[:id])
    @exam_allocation.destroy
    flash[:notice] = 'Exam Allocation deleted successfully.'
    redirect_to exam_allocations_url
  end
end
