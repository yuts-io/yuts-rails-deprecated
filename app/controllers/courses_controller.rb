class CoursesController < ApplicationController
    before_action :require_logged_in
    def index
        @courses = Course.where("season_code = 202103").order(course_code: :asc).limit(150)
    end

    def show
      @course = Course.find_by(id: params[:id])
    end

    private

    def require_logged_in
      redirect_to '/auth/google_oauth2' unless session.include? :user_id
    end

end
