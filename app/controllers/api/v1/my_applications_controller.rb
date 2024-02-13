class Api::V1::MyApplicationsController < ApplicationController
    before_action :set_my_application, only: %i[ show update destroy ]

    # GET /api/v1/my_applications
    def index
      @my_applications = MyApplication.all

      render json: @my_applications
    end

    # GET /api/v1/my_applications/1
    def show
      render json: @my_application
    end

    # POST /api/v1/my_applications
    def create
      @my_application = MyApplication.new(my_application_params)

      if @my_application.save
        render json: @my_application, status: :created
      else
        render json: @my_application.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/my_applications/1
    def update
      if @my_application.update(my_application_params)
        render json: @my_application
      else
        render json: @my_application.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/my_applications/1
    def destroy
      @my_application.destroy!
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_my_application
        @my_application = MyApplication.find_by_token(params[:token])
      end

      # Only allow a list of trusted parameters through.
      def my_application_params
        params.require(:my_application).permit(:name)
      end
end
