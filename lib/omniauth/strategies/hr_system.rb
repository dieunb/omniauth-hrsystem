require "omniauth/strategies/oauth2"
require "rack/utils"
require "uri"

module OmniAuth
 module Strategies
  class HrSystem < OmniAuth::Strategies::OAuth2
    class NoAuthorizationCodeError < StandardError; end
    CUSTOM_PROVIDER_URL = "https://wsm.framgia.vn"

    option :name, "hr_system"

    option :client_options, {
      site: CUSTOM_PROVIDER_URL,
      authorize_url: "#{CUSTOM_PROVIDER_URL}/authorize",
      token_url: "#{CUSTOM_PROVIDER_URL}/auth/access_token"
    }

    uid do
      raw_info["employee_code"]
    end

    info do
      raw_info
    end

    def raw_info
      begin
        @raw_info = access_token.post("me", info_options).parsed
      rescue Exception => e
        return e.response.body
      end
    end

    def info_options
      {params: {access_token: access_token.token}}
    end
  end
 end
end
