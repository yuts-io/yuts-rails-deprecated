class CoursesController < ApplicationController
    before_action :require_logged_in
    def index
      # byebug

      if params[:season] != nil
        @courses = Course.search(nil, params[:season])
      else
        @courses = Course.search(nil, "202103")
      end

    end

    def show
      @course = Course.find_by(id: params[:id])
    end

    def load 
      courses = Course.where("season_code = #{params[:season]}").order(course_code: :asc).offset(500)
      render json: courses
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
