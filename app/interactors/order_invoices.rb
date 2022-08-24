require 'pry'
require_relative '../services/invoices.rb'

module Interactors
  class OrderInvoices
    include Interactor
    RECEIVED = 'received'
    CREDIT_NOTES = 'credit_note'
    CURRENT_USD_VALUE = 800

    def call
      # For each invoice, filter credit notes by reference id
      # and sum the credit notes amount to pay it
      received = context.invoices.select{|invoice| invoice['type'] == RECEIVED }
      credit_notes = context.invoices.select{|invoice| invoice['type'] == CREDIT_NOTES }

      received.map do |received|
        filtered = credit_notes.select do |credit_note|
          credit_note['reference'] == received['id']
        end

        if filtered.empty?
          puts "NO exiten notas de credito asociadas a la factura #{received['id']} \n\n" 
          next
        end

        current_values = filtered.map{|item| { currency: item['currency'], amount: item['amount']}}
        amount = current_values.map do |value|
          value[:currency] == 'CLP' ? value[:amount] : usd_clp(value[:amount])
        end.sum

        received_clp = received['currency'] == 'CLP' ? received['amount'] : usd_clp(received['amount'])
        to_pay = received_clp.to_i - amount

        puts "Para la Factura #{received['id']} - #{received_clp} se pagara #{to_pay}"

        pay_form = Services::Invoices.currency_settings(received['organization_id'])

        pay_form_value = pay_form['currency'] == 'CLP' ? to_pay : usd_clp(to_pay)

        response = Services::Invoices.pay(received['id'], pay_form_value)

        puts "Response: #{response} \n\n"
      end
    end

    def clp_to_usd(currency)
      currency / CURRENT_USD_VALUE
    end

    def usd_clp(currency)
      currency * CURRENT_USD_VALUE
    end
  end
end
