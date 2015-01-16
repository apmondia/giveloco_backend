class Ability
  include CanCan::Ability

  def initialize(user, params)
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      can :read, Sponsorship
      cannot :create, Sponsorship
      cannot :destroy, Sponsorship
      cannot :update, Sponsorship
    end

    if params[:id].to_i == user.id
      can [:read, :create], Certificate
    end

    can :create, Sponsorship, :business_id => user.id

    can :read_purchased_certificates, User, :id => user.id
    can :redeem, Certificate if user.admin?
    can :redeem, Certificate do |certificate|
      user.id == certificate.sponsorship.business.id
    end

    can :manage, User, :id => user.id

  end
end
