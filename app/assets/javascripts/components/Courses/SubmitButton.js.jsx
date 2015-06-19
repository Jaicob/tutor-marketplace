SubmitButton = React.createClass({
  handleCorrectValidation: function(info){

    busy = function(){
      info.courseBox.setState({
        busy: true
      })
    }

    unbusy = function(){
      info.courseBox.setState({
          busy: false
      })
    }

    showFailureMessage = function(){
      swal({
        title: "Update Failed!",
        text: "Please try refreshing the page.",
        type: "error"
      })
      unbusy()
    }

    if(info.courseBox.state.busy){ // PREVENTS SIMULTANEOUS MULTIPLE REQUESTS
      info.courseBox.error("BusyWithAddRequest");
      return
    }

    busy()

    updateReactVirtualDOM = function(){
      updateClient = function(data){
        // UPDATES REACT'S VIRTUALDOM WITH NEW COURSE INFO
        data[0]["rate"] = info.currentCourseRate
        courses = info.savedCourses.concat(data)
        info.courseBox.setState({
          courses: courses
        })

        // NOTIFIES USER OF SUCCESS
        swal({
          title: "Added!",
          text: data[0]["friendly_name"] + " " + data[0]["call_number"],
          type: "success",
          timer: 1000,
          showConfirmButton: false
        });

        info.courseBox.getCourses()

        console.log("CourseSuccessfullyAdded");
        unbusy()
      }

      // GET INFO TO UPDATE VIRTUALDOM
      endpoint = API_LOCATION + '/courses?id=' + info.currentCourseId;
      courseInfo = $.get(endpoint);
      courseInfo.success(updateClient);
      courseInfo.fail(showFailureMessage);
    }

    // SEND COURSE ADD REQUEST,
    endpoint = API_LOCATION + '/tutor_courses'
    courseAddRequest = $.post(endpoint, {
      course: {
        course_id: info.currentCourseId,
        subject_id: info.courseBox.state.selectedSubject,
        school_id: info.courseBox.state.selectedSchool
      },
      tutor_course: {
        tutor_id: info.courseBox.props.tutor_id,
        rate: info.currentCourseRate
      }
    });
    courseAddRequest.success(updateReactVirtualDOM);
    courseAddRequest.fail(showFailureMessage);
  },
  validateInfo: function(info){
    duplicates = info.savedCourses.filter(function(course){
      return course.id == info.currentCourseId
    }).length != 0

    if(!info.currentCourseId){ // VALIDATES COURSE
      info.courseBox.error("NoCourseSelected")
    } else if(!isPositiveInteger(info.currentCourseRate)){  // VALIDATES COURSE RATE
      info.courseBox.error("InvalidCourseRate")
    } else if(info.currentCourseRate > 999){
      info.courseBox.error("RateTooHigh")
    } else if(duplicates){ // VALIDATES IF COURSE IS IN TUTOR'S COURSE LIST
      info.courseBox.error("CourseAlreadyAdded")
    } else { // PASSES VALIDATION
        info.success(info)
    }
  },
  handleClick: function(e){
    courseBox = this.props.parent;
    this.validateInfo({
      courseBox: this.props.parent,
      savedCourses: courseBox.state.courses,
      currentCourseId: courseBox.state.selectedCourse,
      currentCourseRate: courseBox.state.selectedRate,
      success: this.handleCorrectValidation,
    });

    e.preventDefault()
  },
  render: function(){
    style = {
      "marginRight" : "15px"
    }
    return <input type="submit"
                  name="commit"
                  value="Add course"
                  className="button radius success small right"
                  style={style}
                  disabled={!(
                    // describes when the submit button is enabled
                    this.props.parent.state.selectedCourse.length > 0 &&
                    isPositiveInteger(this.props.parent.state.selectedRate) > 0
                  )}
                  onClick={this.handleClick} />
  }
})