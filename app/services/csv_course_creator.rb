class CsvCourseCreator
  require 'csv'

  # x = CsvCourseCreator.new(CsvCourseList.first).format_course_list

  # x = CsvCourseCreator.new(CsvCourseList.first).return_csv_file

  def initialize(csv_course_list)
    @csv_course_list = csv_course_list
  end

  def format_course_list
    data = CSV.parse(open(@csv_course_list.csv_file.url))
    course_list = []
    data.each do |call_number, friendly_name|
      course_list << [call_number, friendly_name]
    end
    return course_list
  end

  def return_csv_file
    @csv_course_list.csv_file
  end

end
