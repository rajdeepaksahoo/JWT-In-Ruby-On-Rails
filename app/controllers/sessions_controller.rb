# class SessionsController < ApplicationController
#
#   # skip_before_action :authenticate_user!, only: [:create]
#
#   def create
#     created = User.new(allowed_params)
#
#     if created.save
#       render json: {
#         message: "User created",
#         user: {
#           id: created.id,
#           username: created.username
#         }
#       }, status: :created
#     else
#       render json: {
#         error: created.errors.full_messages
#       }, status: :unprocessable_entity
#     end
#   end
#
#   def get_token
#     user = User.find_by(username: params[:username]);
#     if user&.authenticate(params[:password_digest])
#       token = JsonWebToken.encode({user_id: user.id});
#       render json: {token:token}, status: :ok;
#     else
#       render json: {error: "Invalid email or password"}, status: :unauthorized
#     end
#   end
#
#   private
#
#   def allowed_params
#     params.permit(:username, :password_digest)
#   end
#
# end


class SessionsController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:create, :get_token]

  def create
    created = User.new(allowed_params)

    if created.save
      render json: {
        message: "User created",
        user: {
          id: created.id,
          username: created.username
        }
      }, status: :created
    else
      render json: {
        error: created.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def get_token
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode({ user_id: user.id })
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid username or password" },
             status: :unauthorized
    end
  end

  private

  def allowed_params
    params.permit(:username, :password)
  end
end
