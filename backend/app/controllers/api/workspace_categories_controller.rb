class Api::WorkspaceCategoriesController < ApplicationController
    before_action :authorize_request
    before_action :set_workspace, only: [:index, :create]

    def index
        categories = @workspace.workspace_categories.select(:id, :name, :color)
        render json: categories
    end

    def create
        category = @workspace.workspace_categories.new(category_params)
        if category.save
            render json: category, status: :created
        else
            render json: { error: category.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        category = WorkspaceCategory.find(params[:id])
        if category.update(category_params)
            render json: category, status: :ok
        else
            render json: { error: category.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        category = WorkspaceCategory.find(params[:id])
        if category.destroy
            render json: { message: 'Category deleted successfully' }, status: :ok
        else
            render json: { error: 'Failed to delete category' }, status: :unprocessable_entity
        end
    end

    private

    def set_workspace
        @workspace = Workspace.find(params[:workspace_id])
    end

    def category_params
        params.require(:workspace_category).permit(:name, :color)
    end
end
