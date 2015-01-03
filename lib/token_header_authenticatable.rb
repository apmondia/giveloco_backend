class TokenHeaderAuthenticable < ::Devise::Strategies::Base
  def valid?
    header.present?
  end

  def authenticate!
    resource_scope = mapping.to
    resource = resource_scope.find_by_authentication_token(header)

    if resource
      success!(resource)
    else
      fail!
    end
  end

  private

  def header
    request.headers["x-session-token"]
  end
end