class ToolsController < ApplicationController
  def index
    @tools = Tool.all
  end

  def show
    @tool = Tool.find(params[:id])
  end

  def new
    @tool = Tool.new
  end

  def create
    @tool = Tool.new(tool_params)
    if @tool.save
      flash[:alert] = "Registered #{@tool.name}!"
      session[:most_recent_tool] = @tool.id
      # session[:most_recent_tool] = current_user.tools.last.id
      session[:current_tool_count] = session[:current_tool_count].to_i + 1
      session[:current_potential_revenue] ||= 0
      session[:current_potential_revenue] += (@tool.price * @tool.quantity)
      current_user.tools << @tool
      redirect_to current_user
    else
      flash[:error] = "Registration failed"
      render :new
    end
  end

  def edit
    @tool = Tool.find_by(user_id: current_user.id)
  end

  def update
    @tool = Tool.find(params[:id])
    if @tool.update(tool_params)
      redirect_to current_user
    else
      render :edit
    end
  end

  def destroy
    @tool = Tool.find(params[:id])
    @tool.destroy
    redirect_to tools_path
  end

  private

  def tool_params #gives us security by only allowing the permitted values to be entered.
    params.require(:tool).permit(:name, :quantity, :price)
  end
end
