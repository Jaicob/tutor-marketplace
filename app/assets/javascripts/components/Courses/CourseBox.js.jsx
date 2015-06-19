(function(){
  isPositiveInteger = function(number){
    return (
      (!isNaN(parseFloat(number)) && isFinite(number)) &&  // checks if it is a number
      number % 1 == 0 && // checks if it is a whole number
      number > 0 // checks if it is greater than 0
    )
  }

  CourseBox = React.createClass({
    getInitialState: function () {
        return {
          selectedSchool: "",
          selectedSubject: "",
          selectedCourse: "",
          selectedRate: "",
          courses: [],
          busy: false
        };
    },
    componentWillMount: function () {
      this.getCourses()
    },
    getCourses: function(){
      if (this.props.tutor_id) {
        $.get(API_LOCATION + '/courses?tutor_id=' + this.props.tutor_id, function(courses){
          this.setState({
            courses: courses
          })
        }.bind(this))
      }
    },
    option: function(key){
      if (this.props[key]){
        return {
          courseList   : <CourseList parent={this} tutor_id={this.props.tutor_id || undefined} />,
          submitButton : <SubmitButton parent={this} />
        }[key]
      }
    },
    error: function(errortype){
        errors = {}
        errors.BusyWithAddRequest = function(){
          console.error("BusyWithAddRequest!");
          swal({
            title: "Woah there!",
            text: "We're still processing your previous request. We should be done any second now. Please check your internet connection if this problem persists.",
            type: "error"
          });
        }
        errors.CourseAlreadyAdded = function(){
          console.error("CourseAlreadyAdded!");
          swal({
            title: "Oops!",
            text: "This course has already been added. You can change your rate by clicking edit button next to it on the course list.",
            type: "error"
          });
        }
        errors.InvalidCourseRate = function(){
          console.error("InvalidCourseRate!");
          swal({
            title: "Whoops!",
            text: "Your rate for this course should be a whole number greater than zero.",
            type: "error"
          });
        }
        errors.NoCourseSelected = function(){
          console.error("NoCourseSelected!");
          swal({
            title: "Whoops!",
            text: "You forgot to select a course!",
            type: "error"
          });
        }
        errors.RateTooHigh = function(){
          console.error("RateTooHigh!");
          swal({
            title: "Woah there!",
            text: "Your rate is too high.",
            type: "error"
          })
        }
        errors.GenericError = function(){
          console.error("GenericError");
          swal({
            title: "Error!",
            text: "Please refresh the page and try again. If this problem persists, please contact dev@axontutors.com",
            type: "error"
          })
        }
        errors[errortype]()
    },
    render: function(){
      return(
        <div className="coursebox">
            <SchoolField parent={this} />
            <SubjectField parent={this} school={this.state.selectedSchool} />
            <CourseField parent={this} school={this.state.selectedSchool} subject={this.state.selectedSubject} />
            <RateField parent={this} course={this.state.selectedCourse} />
            { this.option("submitButton") }
            { this.option("courseList") }
        </div>
      )
    }
  });
})()