class AccountKeyGateway
  include HTTParty

  base_uri ENV['ACCOUNT_KEY_SERVICE']

  def account_key_for(email, key)
    body = {
      email: email,
      key: key
    }

    Rails.logger.info "AccountKeyGateway#POST with #{body}"
    response = self.class.post('/v1/account', body: body)

    case response.code
      when (200..201)
        body = JSON.parse(response.body)
        raise GatewayError.new(self.class.name, response.inspect) if body['email'].nil? || body['account_key'].nil?

        response_email = body['email']
        response_account_key = body['account_key']
        UserAccountKeyService.update(response_email, response_account_key)
      else
        raise GatewayError.new(self.class.name, response.inspect)
    end
  end
end