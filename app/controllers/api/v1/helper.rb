class Api::V1::HelperController < ApplicationController
  
    def show_sql
        render json: MyApplication.all.to_sql
    end
end