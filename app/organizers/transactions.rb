require_relative '../interactors/fetch_invoices.rb'
require_relative '../interactors/order_invoices.rb'

module Organizers
    class Transactions
    include Interactor::Organizer
    
    # Execute those interactors to call and process data
    organize Interactors::FetchInvoices, Interactors::OrderInvoices
  end
end