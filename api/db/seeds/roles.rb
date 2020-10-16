

Role.transaction do

  def update_role!(name, permissions)
    role = Role.find_or_create_by!(name: name)
    role.permissions = permissions.map { |code| Permission.find_or_create_by!(code: code) }
    role.save!
  end

  update_role!('Super Administrador', %I[
    list_admin_users create_admin_user show_admin_user
    update_admin_user destroy_admin_user update_admin_user_role
    list_users create_user show_user update_user destroy_user show_users_banking_info
    list_uploaded_tickets list_digitalized_tickets list_approved_tickets
    show_uploaded_ticket show_digitalized_ticket show_approved_ticket update_uploaded_ticket
    accept_ticket penalize_ticket reject_ticket
    update_digitalized_ticket update_approved_ticket show_ticket_banking_info
    list_roles show_role update_role destroy_role create_role
    list_discounts show_discount update_discount destroy_discount
    list_reviewed_tickets show_reviewed_ticket
    digitalize_ticket
    edit_discount create_discount
    list_segments show_segment create_segment update_segment destroy_segment
    list_digitalized_tickets show_digitalized_ticket review_ticket
    list_unsegmented_tickets show_unsegmented_ticket assign_segments_to_ticket
    export_database
    import_user_segments
    send_push_notifications
    list_products update_product destroy_product edit_product create_product show_product
    list_ticket_gallery show_ticket_gallery
  ])

  update_role!('Administrador', %I[
    list_admin_users create_admin_user show_admin_user
    update_admin_user destroy_admin_user
    list_users create_user show_user update_user show_users_banking_info
  ])

  update_role!('Reviewer de Tickets', %I[
    list_uploaded_tickets show_uploaded_ticket update_uploaded_ticket accept_ticket reject_ticket
    penalize_ticket
  ])

  update_role!('Data Entry', %I[
    list_digitalized_tickets show_digitalized_ticket update_digitalized_ticket show_reviewed_ticket
  ])

  update_role!('Manager de Promociones', %I[
    list_discounts show_discount update_discount edit_discount create_discount
  ])
end
