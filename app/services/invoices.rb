require_relative './api_bemmbo.rb'

module Services
  class Invoices
    @@client = Services::ApiBemmbo.new

    # Method to call markets from buda using Faraday Client method
    def self.fetch
      @@client.fetch("invoices/pending")
    end

    def self.currency_settings organization_id
      @@client.fetch("organization/#{organization_id}/settings")
    end

    def self.pay invoice_id, amount
      @@client.fetch("invoices/#{invoice_id}/pay", :post, { "amount": amount })
    end
  end
end