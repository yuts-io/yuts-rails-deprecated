class CoursesController < ApplicationController
    before_action :require_logged_in
    def index
      # byebug

      if params[:search] != nil
        session[:search] = params[:search]
        @courses = Course.search(session[:search])
      else
        @courses = Course.search(nil)
      end

      if params[:guts_switch]
        @courses = @courses.where("gut_index > 80").order(course_code: :asc)
      end

      # byebug
      
      
        # byebug
        # @courses = @courses.filter_by_gut_index if params[:guts_switch] == "on"
    

    end

    def search
      # byebug
      courses = Course.search(params[:search_val])
      render json: courses
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
