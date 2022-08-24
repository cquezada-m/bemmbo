require_relative '../services/invoices.rb'
require 'interactor'

# interactor to fetch all invoices available in bemmbo and share into app trought context
module Interactors
  class FetchInvoices
    include Interactor

    def call
      # api call to fetch invoices
      if response = Services::Invoices.fetch
        # if is successfully, set invoices as a context
        context.invoices = response
      else
        context.fail!(message: ":c something went wrong")
      end
    end
  end
end
