module Api
  module V1
    class ProductsController < ApiController
      skip_before_action :authenticate_user!, only: [:index]

      def index
        render json: Product.search(params[:term])
      end
    end
  end
end
