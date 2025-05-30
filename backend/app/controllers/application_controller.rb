class ApplicationController < ActionController::API
    before_action :authorize_request

    def authorize_request
        header = request.headers['Authorization']
        token = header.split(' ').last if header
        decoded = JsonWebToken.decode(token)

        @current_user = User.find(decoded[:user_id]) if decoded
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
    end

    def current_user
        @current_user
    end
end
