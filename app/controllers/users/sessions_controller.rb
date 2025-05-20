class Users::SessionsController < Devise::SessionsController
  respond_to :json
 

  private

  def respond_with(resource, _opts = {})
   token = request.env['warden-jwt_auth.token']
  puts "JWT token dispatched: #{token.inspect}"
  puts "🔍 Path: #{request.path}"
puts "🧪 Token: #{request.env['warden-jwt_auth.token'].inspect}"


    render json: {
        path: request.path,
        token: token,
      status: { code: 200, message: 'Logged in successfully.' },
      data: {
        id: resource.id,
        email: resource.email
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    render json: {
      status: 200,
      message: "Logged out successfully."
    }, status: :ok
  end
end
