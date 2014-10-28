class ProblemsController < ApplicationController
  before_action :set_problem, only: [:show, :resolve]

  def new
    @problem = Problem.new
  end

  def create
    @problem = Problem.new(problem_params)
    @user = current_user
    if @problem.save
      redirect_to problem_path(@problem.id), notice: "Problem saved successfully"
      UserMailer.problem_posted(@user, @problem).deliver
    else
      render :new, notice: "Invalid problem input"
    end
  end

  def index
    @problems = Problem.all
  end

  def show
    @note = Note.new
  end

  def resolve
    @problem.toggle(:resolved)
    @problem.save
    respond_to do |format|
      format.html do
        redirect_to root_path, notice: "Problem resolved!"
      end
      format.js do
        render :resolve, status: :ok
      end
    end
  end

  private

  def set_problem
    @problem = Problem.find(params[:id])
  end

  def problem_params
    params.require(:problem).permit(:user_id, :description, :tried )
  end
end
