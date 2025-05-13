require 'json_web_token'

module Api
    module User
        class AuthController < ApplicationController
            skip_before_action :authorize_request, only: [:signup, :login]

            # 新しいユーザーを登録
            def signup
                user = ::User.new(user_params)
                if user.save
                    render json: { user: user.slice(:id, :name, :email) }, status: :created
                else
                    render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
                end
            end

            # 登録されている情報でログイン
            def login
                user = ::User.find_by(email: params[:user][:email])
                if user&.authenticate(params[:user][:password])
                    token = JsonWebToken.encode(user_id: user.id)
                    render json: { token: token, user: user.slice(:id, :name, :email) }, status: :ok
                else
                    render json: { error: 'Invalid email or password' }, status: :unauthorized
                end
            end

            # ログアウト
            def logout
                render json: { message: 'Logged out successfully' }, status: :ok
            end

            # ユーザー情報を更新
            def update_name
                user = current_user
                if user.update(name: params[:user][:name])
                    render json: { message: 'Name updated successfully', user: user.slice(:id, :name, :email) }, status: :ok
                else
                    render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
                end
            end

            # パスワードを更新
            def update_password
                user = current_user
                if user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
                    render json: { message: 'Password updated successfully' }, status: :ok
                else
                    render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
                end
            end

            # ユーザー自身の情報を取得
            def me
                header = request.headers['Authorization']
                token = header.split(' ').last if header
                decoded_token = JsonWebToken.decode(token)
                user = ::User.find(decoded_token[:user_id])
                render json: { user: user.slice(:id, :name, :email) }, status: :ok
            rescue ActiveRecord::RecordNotFound, JWT::DecodeError
                render json: { error: 'Invalid token' }, status: :unauthorized
            end

            private

            def user_params
                params.require(:user).permit(:name, :email, :password, :password_confirmation)
            end
        end
    end
end
