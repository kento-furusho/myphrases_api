class ApplicationController < ActionController::API
        include DeviseTokenAuth::Concerns::SetUserByToken
        rescue_from ActiveRecord::RecordNotFound, with: :render_404
        before_action :configure_permitted_parameters, if: :devise_controller?

        def render_404
                render status: 404, json: { message: "recoed not found. "}
        end

        # nameカラムを追加
        def configure_permitted_parameters
                devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
        end
end
