class Api::TasksController < ApplicationController
    before_action :authorize_request
    before_action :set_task, only: [:show, :destroy, :update]

    def create
        task = Task.new(task_params)
        task.workspace_id = params[:workspace_id]
        # task.created_by_user_id = @current_user.id
        task.workspace_category_id = WorkspaceCategory.find_by(workspace_id: params[:workspace_id])&.id

        if task.save
            render json: { task: task }, status: :created
        else
            render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def index
        tasks = Task.where(workspace_id: params[:workspace_id])
        render json: { tasks: tasks }, status: :ok
    end

    def show
        render json: { task: @task.as_json(include: { workspace_category: { only: [:id, :name, :color] } }) }, status: :ok
    end

    def filter
        tasks = Task.where(workspace_id: params[:workspace_id])

        if params[:search_query].present?
            query = "%#{params[:search_query]}%"
            tasks = tasks.left_joins(:workspace_category, :task_assignments => :user)
            .where("tasks.name LIKE :q OR workspace_categories.name LIKE :q OR users.name LIKE :q", q: query)
            .distinct
        end

        render json: { tasks: tasks }
    end

    def update
        if @task.update(task_params)
            render json: { task: @task }, status: :ok
        else
            render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @task.destroy
        render json: { message: 'Task deleted successfully' }, status: :ok
    end

    private

    def task_params
        params.require(:task).permit(:name, :description, :status, :due_date, :workspace_category_id)
    end

    def set_task
        @task = Task.find(params[:id])
    end
end
