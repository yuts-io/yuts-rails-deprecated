class CoursesController < ApplicationController
    before_action :require_logged_in
    def index
      # byebug
      if !params[:filter]
        @courses = Course.search(params[:search])
      else
        # byebug
        @courses = Course.filter.search(params[:search])
      end

    end

    def show
      @course = Course.find_by(id: params[:id])
    end

    def load 
      courses = Course.where("season_code = #{params[:season]}").order(course_code: :asc).offset(params[:amount])
      render json: courses
    end

    def new_season_home
      @courses = Course.where("season_code = #{params[:season]}").order(course_code: :asc).limit(150)
    end

    private

    def require_logged_in
      redirect_to '/auth/google_oauth2' unless session.include? :user_id
    end

end
