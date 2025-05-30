class InvitesController < ApplicationController
  before_action :authenticate_user!

  def create
    business = current_user.businesses.find(params[:business_id])
    invite = business.invites.create!(inviter: current_user, expires_at: 3.days.from_now)

    render json: { code: invite.code }, status: :created
  end

  def accept
    invite = Invite.find_by(code: params[:code])

    if invite && invite.expires_at > Time.current
      UserBusiness.create!(user: current_user, business: invite.business, role: 'staff')
      invite.destroy # Optional: remove code after use
      render json: { message: "Joined business successfully." }
    else
      render json: { error: "Invite is invalid or expired." }, status: :unprocessable_entity
    end
  end
end