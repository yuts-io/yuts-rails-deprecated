class CoursesController < ApplicationController
    before_action :require_logged_in
    def index
      # byebug

      if params[:search] != nil
        session[:search] = params[:search]
        @courses = Course.search(session[:search], "202103")
      else
        @courses = Course.search(nil, "202103")
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
      if params[:search_val] != nil
        courses = Course.search(params[:search_val])
      else
        courses = Course.search(nil)
      end
      render json: courses
    end 

    def show
      @course = Course.find_by(id: params[:id])
    end

    def load 
      courses = Course.where("season_code = #{params[:season]}").order(course_code: :asc).offset(500)
      render json: courses
    end

    def new_season_home
      @courses = Course.where("season_code = #{params[:season]}").order(course_code: :asc).limit(500)
    end

    def sort_init
      courses = Course.where("season_code = #{params[:season]} AND #{params[:sorter]} IS NOT NULL").order("#{params[:sorter]} #{params[:direction]}").limit(150)
      render json: courses
    end

    def sort_more
      courses = Course.where("season_code = #{params[:season]}").order("#{params[:sorter]} ASC").offset(150)
      render json: courses
    end

    private

    def require_logged_in
      redirect_to '/auth/google_oauth2' unless session.include? :user_id
    end

end
