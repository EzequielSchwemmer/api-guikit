module FakeModels
  class RolePermissions < Base
    class <<self
      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, 'permissions')
      end
    end

    PERMISSION_SETS = {
      admin_user: %i[
        list_admin_users create_admin_user show_admin_user update_admin_user destroy_admin_user
      ],
      role: %i[list_roles create_role show_role update_role destroy_role],
      user: %i[list_users create_user show_user update_user destroy_user],
      segment: %i[list_segments show_segment create_segment update_segment destroy_segment],
      discount: %i[
        list_discounts create_discount show_discount update_discount destroy_discount
      ],
      ticket: %i[
        list_uploaded_tickets list_reviewed_tickets list_digitalized_tickets list_approved_tickets
        show_uploaded_ticket show_reviewed_ticket show_digitalized_ticket
        reject_ticket accept_ticket digitalize_ticket revert_review
        list_digitalized_tickets show_digitalized_ticket review_ticket
        show_ticket_banking_info list_ticket_gallery show_ticket_gallery
      ],
      database: %i[export_database import_user_segments export_audits],
      push_notification: %i[send_push_notifications],
      unsegmented_ticket: %i[
        list_unsegmented_tickets show_unsegmented_ticket assign_segments_to_ticket
      ],
      product: %i[
        list_products create_product show_product update_product destroy_product
      ],
      reward: %i[send_custom_rewards]
    }.freeze

    attr_accessor(*::Permission.codes.keys)

    def permission_sets
      PERMISSION_SETS.keys
    end

    def permissions_for(set)
      PERMISSION_SETS[set]
    end
  end
end
