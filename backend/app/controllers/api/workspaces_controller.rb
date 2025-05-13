class Api::WorkspacesController < ApplicationController
  before_action :authorize_request

  # 全体ワークスペース一覧を取得
  def index
    workspaces = current_user.workspaces
    render json: workspaces.select(:id, :name, :description, :created_at)
  end

  # ワークスペースを作成
  def create
    workspace = current_user.workspaces.create!(workspace_params)
    workspace.create_invitation_code!(code: SecureRandom.hex(6))
    render json: { id: workspace.id, name: workspace.name }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  # 特定ワークスペースの詳細を取得
  def show
    workspace = Workspace.find(params[:id])
    if workspace.users.include?(current_user)
      render json: workspace.slice(:id, :name, :description, :created_at)
    else
      render json: { error: 'Access denied' }, status: :forbidden
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Workspace not found' }, status: :not_found
  end

  # ワークスペースを更新
  def update
    workspace = Workspace.find(params[:id])
    if workspace.users.include?(current_user)
      if workspace.update(workspace_params)
        render json: { message: 'Workspace updated successfully' }
      else
        render json: { error: workspace.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Access denied' }, status: :forbidden
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Workspace not found' }, status: :not_found
  end

  # ワークスペースを削除
  def destroy
    workspace = Workspace.find(params[:id])
    if workspace.users.include?(current_user)
      workspace.destroy
      render json: { message: 'Workspace deleted successfully' }
    else
      render json: { error: 'Access denied' }, status: :forbidden
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Workspace not found' }, status: :not_found
  end

  # ワークスペースのユーザー一覧を取得
  def users
    workspace = Workspace.find(params[:id])
    if workspace.users.include?(current_user)
      render json: workspace.users.select(:id, :name, :email)
    else
      render json: { error: 'Access denied' }, status: :forbidden
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Workspace not found' }, status: :not_found
  end

  # ワークスペースの招待コードを取得
  def invitation_code
    workspace = Workspace.find(params[:id])
    if workspace.users.include?(current_user)
      render json: { code: workspace.invitation_code&.code }
    else
      render json: { error: 'Access denied' }, status: :forbidden
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Workspace not found' }, status: :not_found
  end

  private

  def workspace_params
    params.require(:workspace).permit(:name, :description)
  end
end
