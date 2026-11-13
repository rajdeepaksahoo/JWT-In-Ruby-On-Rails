# frozen_string_literal: true

module Authenticatable extend ActiveSupport::Concern
  included do
    before_action :authenticate_user!
  end

  
  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last;
    return render json:{ message:"Invalid token"}, status: :unauthorized unless token;
    begin
      decode = JsonWebToken.decode(token)
      user_id = decode["user_id"]
      @current_user = User.find(user_id);
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: {message: "Invalid User"}, status: :unauthorized
    end
  end
end
