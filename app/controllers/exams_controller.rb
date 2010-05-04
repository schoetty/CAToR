class ExamsController < ApplicationController
  before_filter :authorized?

  def new
    @exam = Exam.new
    @category_id = params[:id] rescue nil
  end

  def create
    @exam = Exam.new params[:exam]

    if @exam.save
      flash[:notice] = 'Exam is up and running'
      exam_allocation = ExamAllocation.find_by_category_id @exam.category_id
#      exam_allocation.destroy       # destroy the allocation for the current exam
      session[:exam_id] = @exam.id  # save the exam id to the session cookie
      redirect_to proceed_path
    else
      flash[:error] = 'Could not start exam.'
      redirect_to welcome_path
    end
  end

  def proceed
    @exam = Exam.find session[:exam_id]
    @category = Category.find @exam.category_id
    session[:sequence] = 0 if @exam.solutions.count == 0

    if params[:solution]  # if there is an answer in the queue
      latency = Time.now.to_f - session[:item_start_time]  # calculate latency in seconds
      session[:sequence] += 1  # solution counter

      @content = params[:solution]
      @item_id = params[:solution][:item_id]

      ### Solved item correct? ###
      @no_of_correct_solutions = 0
      PossibleSolution.find_all_by_item_id(@item_id).each do |ps|
        @no_of_correct_solutions += 1 if ps.correct == 1
      end
      correct_solution = 0
      @incorrect_selected = 0
      @content.each do |solution|
        if solution[1] == "1"  # solution selected?
          if PossibleSolution.correct? solution[0].to_i
            correct_solution += 1  # correct solution selected
          else
            @incorrect_selected = 1  # wrong solution selected
          end
        end unless solution[0] == "item_id"
      end

      if @no_of_correct_solutions == correct_solution and @incorrect_selected != 1
        @item_correct = 1
      else
        @item_correct = 0
      end

      # calculate P(THETA)
      item_difficulty = Item.find(@item_id).level.difficulty
      p = 1 / (1 + Math.exp(-1.701*(@exam.theta - item_difficulty)))

      @current_solution = Solution.create(  :item_id => @item_id,
                        :exam_id => @exam.id,
                        :latency => latency,
                        :content => @content,
                        :p => p,
                        :sequence => session[:sequence],
                        :correctness => @item_correct )

      ### calculate the standard error ###
      @i = 0.0 if !@i
      @s = 0.0 if !@s
      @exam.solutions.each do |solution|
        @i += solution.p * ( 1 - solution.p ) # test information function
        @s += ( solution.correctness - solution.p )
      end
      @sem = Math.sqrt( 1 / @i )
      puts "SEM = #{@sem}"

      ### estimate examinee's ability ###
      @theta = @exam.theta
      delta = ( @s / @i )
      if delta > 0 then delta = 0.5 else delta = -0.5 end if delta.abs > 0.5
      @theta += delta

      # begin monitoring code
      puts "THETA = #{@theta}"
      # create a comma seperated list of estimated thetas
      unless @exam.thetas.blank?
        @exam.thetas += ",#{@theta}"
      else
        @exam.thetas = @theta
      end
      @num_of_items = String.new
      (1..session[:sequence]).each { |x| @num_of_items << "#{x}|" }
      # end monitoring code

      @exam.update_attribute :theta, @theta


      ### Abortion criterion ###
      # example for a fixed length test with 20 items and a testing time of 10 minutes
      # unless @exam.solutions.count == 20 or ( Time.now.to_f - @exam.created_at.to_f ) / 60 >= 10

      ### use the SEM for abortion ##
      if @sem > 0.33

      ### Choose next item ###
      diff = Exam.dif @exam.theta

      # make sure every item is presented only once
      @presented_items = Array.new
      @exam.solutions.each { |s| @presented_items << s.item_id }

      @item = Item.random @category.id, diff, @presented_items
      if @item == nil
        session[:error_message] = "couldn't find next item. propably all items with
                                   the right difficulty are already used in this exam.
                                   try to add more items in the database."
        redirect_to error_path
      end

      @possible_solutions = @item.possible_solutions.sort_by { rand } rescue nil

      else
        redirect_to conclusion_path  # termination criterion matched -> redirect
      end

    else  # if no question was answered before
      @exam.update_attribute :theta, 0.0  # set initial theta to 0
      # select a random item with difficulty 0 to present first
      @item = Item.random @category.id, 0, []
      # randomize the array
      @possible_solutions = @item.possible_solutions.sort_by { rand }
    end
    # setting start time
    session[:item_start_time] = Time.now.to_f
  end

  def conclusion
    @exam = Exam.find session[:exam_id]
    @category = Category.find @exam.category_id

    # monitoring code
    @num_of_items = String.new
    (1..session[:sequence]).each { |x| @num_of_items << "#{x}|" }
  end

  def error
    if session[:error_message].blank?
      @error = "an unexpected error occurred. please contact the administrator"
    else
      @error = session[:error_message]
    end
  end
end