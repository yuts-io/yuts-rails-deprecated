class GradesController < ApplicationController
    skip_before_action :verify_authenticity_token
    def create 
        @course = Course.find(params[:course_id])

        user_id = session[:user_id]

        @grade = Grade.create(course_id: params[:course_id], grade: params[:grade])
    end

end