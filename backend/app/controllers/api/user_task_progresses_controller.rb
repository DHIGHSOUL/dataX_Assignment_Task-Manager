class Api::UserTaskProgressesController < ApplicationController
    before_action :authorize_request

    def index
        workspace = Workspace.find(params[:workspace_id])
        progresses = TaskProgress.where(workspace_id: workspace.id)
        .includes(:user)
        .map do |progress|
            {
                user_id: progress.user_id,
                user_name: progress.user.name,
                total_tasks: progress.total_tasks,
                completed_tasks: progress.completed_tasks,
                progress: progress.progress_rate,
            }
        end

        render json: progresses, status: :ok
    end
end
