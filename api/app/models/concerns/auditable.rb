module Concerns
  module Auditable
    extend ActiveSupport::Concern

    included do
      audited max_audits: Rails.application.secrets.max_audits
    end
  end
end
