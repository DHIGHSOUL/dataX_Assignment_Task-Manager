class Api::TaskAssignmentsController < ApplicationController
    before_action :authorize_request

    def create
        assignment = TaskAssignment.new(task_id: params[:task_id], user_id: params[:user_id])
        if assignment.save
            render json: { message: 'Task assignment created successfully' }, status: :created
        else
            render json: { error: assignment.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def index
        task = Task.find(params[:task_id])
        users = task.assigned_users.select(:id, :name)
        render json: users
    end

    def destroy
        assignment = TaskAssignment.find_by(task_id: params[:task_id], user_id: params[:user_id])
        if assignment
            if assignment.destroy
                render json: { message: 'Task assignment deleted successfully' }, status: :ok
            else
                render json: { error: 'Failed to delete task assignment' }, status: :unprocessable_entity
            end
        else
            render json: { error: 'Task assignment not found' }, status: :not_found
        end
    end
end
