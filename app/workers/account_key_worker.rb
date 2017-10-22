class AccountKeyWorker
  include Sidekiq::Worker

  def perform(email, key)
    begin
    Rails.logger.info "#{self.class.name}: Retrieving account key for #{email}"
    AccountKeyGateway.new.account_key_for email, key

    rescue GatewayError => gateway
      Rails.logger.info "#{self.class.name}: Failed to retrieve account key for #{email}. Retry in 10 minutes: #{gateway.message}"
      self.class.perform_in(10.minutes, email, key)
    rescue ActiveRecord::RecordNotFound => not_found
      Rails.logger.info "#{self.class.name}: Update account key for #{email} failed and will not be re-tryed: #{not_found.message}"
    rescue StandardError => e
      Rails.logger.info "#{self.class.name}: Job failed and will not be re-tryed. #{email}: #{e.message}"
    end
  end
end