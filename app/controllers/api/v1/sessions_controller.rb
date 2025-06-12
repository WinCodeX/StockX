module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      def create
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)

        token = request.env['warden-jwt_auth.token']

        render json: {
          token: token,
          user: {
            id: resource.id,
            email: resource.email,
            username: resource.username,
            avatar_url: url_for(resource.avatar) if resource.avatar.attached?
          }
        }, status: :ok
      end

      private

      def respond_to_on_destroy
        head :no_content
      end
    end
  end
end