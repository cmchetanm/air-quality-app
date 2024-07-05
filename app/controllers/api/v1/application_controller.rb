module Api
  module V1
    class ApplicationController < ActionController::Base
      around_action :handle_exceptions

      private

      def handle_exceptions
        begin
          yield
        rescue ActiveRecord::RecordNotFound => e
          render json: { message: e.message }, status: :not_found
        rescue ArgumentError => e
          render json: { message: e.message }, status: :bad_request
        rescue Net::HTTPError => e
          render json: { message: e.message }, status: :bad_gateway
        rescue StandardError => e
          render json: { message: 'Unknown Failure' }, status: :internal_server_error
        end
      end
    end
  end
end