describe Admin::BankingInfosController do
  let(:model_class_factory) { :banking_info }

  include_examples 'unauthorized show admin examples'
end
