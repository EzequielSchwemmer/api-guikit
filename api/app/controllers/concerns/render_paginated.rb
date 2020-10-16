module RenderPaginated
  extend ActiveSupport::Concern

  def render_paginated(
    records_collection,
    included_models: [],
    per_page:,
    serializer: nil,
    params: nil
  )
    options = { include: included_models, params: params }.merge(
      pagination_options(records_collection, per_page)
    )
    render json: paginated_records(serializer, records_collection, per_page, options)
  end

  private

  def pagination_options(collection, per_page)
    collection_size = collection.count.to_f
    current_page = params[:page].presence || 1
    total_pages = (collection_size / (per_page == 0.0 ? collection_size : per_page.to_f)).ceil
    {
      meta: {
        total_pages: total_pages, total: collection_size,
        page_size: per_page, current_page: current_page
      }
    }
  end

  def paginated_records(serializer, collection, per_page, options)
    if serializer.nil?
      paginate(collection, per_page: per_page)
    else
      resources = paginate(collection, per_page: per_page)
      serializer.new(
        resources,
        options.merge(meta: options[:meta].merge(page_count: resources.count))
      )
    end
  end
end
