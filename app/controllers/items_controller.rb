class ItemsController < ApplicationController

  before_filter :admin_authorized?

  def index
    @categories = Category.all
    @items = Item.categorize(params[:category], params[:page])
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
    8.times do @item.possible_solutions.build end
    @categories = Category.all
    @levels = Level.all
  end

  def edit
    @item = Item.find(params[:id])
    @categories = Category.all
    @levels = Level.all
  end

  def create
    @categories = Category.all # just for validation
    @levels = Level.all        # just for validation
    @item = Item.new(params[:item])
    
    params[:possible_solutions].each_value do |possible_solution|
      # save all solutions unless there's no content
      @item.possible_solutions.build(possible_solution) unless possible_solution.values[1].blank?
    end

    if @item.save
      flash[:notice] = 'Item was successfully created.'
      redirect_to(@item)
    else
      render :action => "new"
    end
  end

  def update
    @categories = Category.all # just for validation
    @levels = Level.all        # just for validation
    @item = Item.find(params[:id])
    @item.update_attributes(params[:item])

    @item.possible_solutions.each { |t| t.update_attributes(params[:possible_solution][t.id.to_s]) }
    if @item.valid? && @item.possible_solutions.all?(&:valid?)
      @item.save!
      @item.possible_solutions.each(&:save!)
      flash[:notice] = 'Item was successfully updated.'
      redirect_to(@item)
    else
      render :action => "edit"
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.possible_solutions.each { |t| t.destroy } # destroy all possible solutions for that item
    @item.destroy # destroy the item
    redirect_to(items_url)
  end
end
