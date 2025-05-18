class Api::UserWorkspacesController < ApplicationController
  before_action :authorize_request

  # ユーザーが所属しているワークスペース一覧を取得
  def index
    render json: current_user.workspaces
  end

  # ワークスペースに参加
  def join
    code = params[:code]
    invitation = InvitationCode.find_by(code: code)

    if invitation && invitation.workspace
      workspace = invitation.workspace
      unless workspace.users.include?(current_user)
        workspace.users << current_user
      end
      render json: { message: 'Joined workspace successfully' }
    else
      render json: { error: 'Invalid invitation code' }, status: :not_found
    end
  end

  # ワークスペースで脱退
  def leave
    workspace = current_user.workspaces.find(params[:id])
    if workspace
      TaskAssignment
        .joins(:task)
        .where(user_id: current_user.id, tasks: { workspace_id: workspace.id })
        .destroy_all

      current_user.workspaces.delete(workspace)

      render json: { message: 'Left workspace successfully' }
    else
      render json: { error: 'Workspace not found' }, status: :not_found
    end
  end
end
