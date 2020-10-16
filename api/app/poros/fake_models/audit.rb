module FakeModels
  class Audit < Base
    class <<self
      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, 'Audit')
      end
    end

    include ActiveModel::Attributes

    attribute :since, :date, default: -> { 1.month.ago }
    attribute :upto, :date, default: -> { Date.current }
    attribute :limit, :integer, default: -> { 10_000 }
    attribute :offset, :integer, default: -> { 0 }

    validates :since, :upto,
              timeliness: { on_or_before: :today, type: :date, message: :before_today }

    validates :since, timeliness: { on_or_before: :upto, type: :date, message: :before_upto }
    validates :upto, timeliness: { on_or_after: :since, type: :date, message: :after_since }

    validates :limit, :offset, numericality: { only_integer: true }
    validates :limit, inclusion: { in: 1..100_000 }, allow_blank: true

    def to_csv
      (header + resources).join("\n")
    end

    private

    def header
      [['Fecha y hora', 'Autor', 'Acción', 'Cambios', 'Estado'].join(';')]
    end

    def resources
      filter_audits!.map(&method(:map_audit))
    end

    def filter_audits!
      validate!
      Audited
        .audit_class
        .includes(:user, :auditable)
        .where(created_at: since.beginning_of_day..upto.end_of_day)
        .order(created_at: :desc)
        .limit(limit).offset(offset)
    end

    def map_audit(audit)
      author = audit.user&.name.presence || '(Sistema)'
      [
        audit.created_at.to_json,
        author,
        audit.action.to_json,
        audit.changes.to_json.to_json,
        audit.auditable.to_json.to_json
      ].join(';')
    end
  end
end
