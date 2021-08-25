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
      courses = Course.where("season_code = #{params[:season]} AND #{params[:sorter]} IS NOT NULL").order("#{params[:sorter]} #{params[:direction]}").limit(250)
      render json: courses
    end

    def sort_more
      courses = Course.where("season_code = #{params[:season]} AND #{params[:sorter]} IS NOT NULL").order("#{params[:sorter]} #{params[:direction]}").offset(250)
      render json: courses
    end

    def handle_user_review
      @course = Course.find(params[:id])

      user_id = session[:user_id]
      if params[:grade] != "N/A"
        @grade = Grade.create(course_id: params[:id], grade: params[:grade])
      end

      if params[:grade] != "N/A"
        grade_submitted = true
      else
        grade_submitted = false
      end

      @user_review = UserReview.create(course_id: params[:id], user_id: user_id, is_a_gut: params[:gut], enjoyed_class: params[:enjoyed], submitted_grade: grade_submitted, good_prof: params[:prof], good_workload: params[:work])

      redirect_to course_path(@course)
    end

    private

    def require_logged_in
      redirect_to '/auth/google_oauth2' unless session.include? :user_id
    end

end
