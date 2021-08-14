class CoursesController < ApplicationController

    def index
        @courses = Course.where("season_code = 202103").order(course_code: :asc)
    end
end
