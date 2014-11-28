class Ability
  include CanCan::Ability

  def initialize(user, params)
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      cannot :manage, Sponsorship
    end

    if params[:id].to_i == user.id
      can [:read, :create], Certificate
    end

    can :resolve, Sponsorship do |s|
      s.cause.try(:id) == user.id
    end

    can :redeem, Certificate if user.admin?
    can :redeem, Certificate do |certificate|
      user.id == certificate.sponsorship.business.id
    end

    can :manage, User, :id => user.id

  end
end
