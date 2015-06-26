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
      } else{
        return ""
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
    update: function(){
      updates = {}

      updates.school = function(school, subject, course, rate){
        school = school? school.target.value : this.state.selectedSchool

        if (subject) {
          // new subject selected -> select that subject in the view model
          subject = subject.target.value
        } else {
          if(school != this.state.selectedSchool){
            // new school selected -> unselect current subject
            subject = ""
          } else {
            // same school and subject -> do nothing
            subject = this.state.selectedSubject
          }
        }

        if (course) {
          // new course selected -> select that course in the view model
          course = course.target.value
        } else {
          if(school != this.state.selectedSchool || subject != this.state.selectedSubject){
            // new school or subject selected -> unselect current course
            course = ""
          } else {
            // same school, subject, and course -> do nothing
            course = this.state.selectedCourse
          }
        }

        if(rate){
          rate = rate.target.value
        } else {
          if (course == "") {
            rate = ""
          } else {
            rate = this.state.selectedRate
          }
        }

        this.setState({
          "selectedSchool" : school,
          "selectedSubject": subject,
          "selectedCourse" : course,
          "selectedRate"   : rate
        })
      }.bind(this)

      updates.subject = function(subject, course, rate){
        updates.school(null, subject, course || null, rate || null)
      }

      updates.course = function(course, rate){
        updates.subject(null, course, rate || null)
      }

      updates.rate = function(rate){
        updates.course(null, rate)
      }

      return updates
    },
    render: function(){
      return(
        <div className="coursebox">
            <SchoolField update={this.update().school}/>
            <SubjectField update={this.update().subject} school={this.state.selectedSchool} />
            <CourseField update={this.update().course} school={this.state.selectedSchool} subject={this.state.selectedSubject} />
            <RateField update={this.update().rate} course={this.state.selectedCourse} />
            { this.option("submitButton") }
            { this.option("courseList") }
        </div>
      )
    }
  });
})()