(function(){
  var API_LOCATION = window.location.origin

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
            <RateField parent={this} />
            { this.option("submitButton") }
            { this.option("courseList") }
        </div>
      )
    }
  });

  SchoolField = React.createClass({
    update: function(event){
      this.props.parent.setState({
        selectedSchool: event.target.value,
        selectedSubject: "",
        selectedCourse: "",
      })
    },
    getInitialState: function () {
        return {
            all_schools: []
        };
    },
    componentDidMount: function (nextProps) {
        $.get(API_LOCATION + '/schools', function(data){
          this.setState({
            all_schools: data
          })
        }.bind(this));
    },
    render: function(){
      return (
        <div className="medium-3 columns">
          <select name="course[school_id]" defaultValue="Course" onChange={this.update}>
            <option disabled="true">School</option>
            {
              this.state.all_schools.map(function(school){
                return <option key={school.id} value={school.id}>{school.name}</option>
              })
            }
          </select>
        </div>
      )
    }
  });

  SubjectField = React.createClass({
    update: function(event){
        this.props.parent.setState({
          selectedSubject: event.target.value,
          selectedCourse: "",
        })
    },
    getInitialState: function(){
      return {
          all_subjects: []
      };
    },
    componentWillReceiveProps: function (nextProps) {
      if (nextProps.school && nextProps.school != this.props.school) {
        $.get(API_LOCATION + '/subjects?school_id=' + nextProps.school, function(data){
          this.setState({
            all_subjects: data
          });
        }.bind(this));
      } else if(!nextProps.school) {
        this.setState({
          all_subjects: []
        })
      }
    },
    render: function(){
      return (
        <div className="medium-3 columns">
          <select name="course[subject_id]" defaultValue="Course" disabled={this.state.all_subjects.length < 1} onChange={this.update} >
            <option disabled="true">Subject</option>
            {
              subjects = this.state.all_subjects.map(function(subject){
                return <option key={subject.id} value={subject.id}>{subject.name}</option>
              })
            }
          </select>
        </div>
      )
    }
  });

  CourseField = React.createClass({
    update: function(event){
      this.props.parent.setState({
        selectedCourse: event.target.value
      })
    },
    getInitialState: function () {
        return {
          all_courses: []
        };
    },
    componentWillReceiveProps: function (nextProps) {
      if(nextProps.school && nextProps.subject){ // neither school or subject are empty
        if (nextProps.school != this.props.school || nextProps.subject != this.props.subject){ // one of them changed
            url = API_LOCATION + '/courses?school_id=' + nextProps.school + '&subject_id=' + nextProps.subject
            $.get(url, function(data){
              this.setState({
                all_courses: data
              });
            }.bind(this));
          } else{
            // school or subject are filled but should not change
          }
      } else {
        this.setState({
          all_courses: []
        })
      }
    },
    render: function(){
      return (
        <div className="medium-3 columns">
          <select name="course[course_id]" defaultValue="Course" disabled={this.state.all_courses.length < 1} onChange={this.update}>
            <option disabled="true">Course</option>
            {
              this.state.all_courses.map(function(course){
                return <option key={course.id} value={course.id}>{course.call_number}</option>
              })
            }
          </select>
        </div>
      )
    }
  })

  RateField = React.createClass({
    update: function(event){
      this.props.parent.setState({
        selectedRate: event.target.value
      })
    },
    render: function(){
      return (
        <div className="medium-3 columns">
          <input type="number"
                      name="tutor_course[rate]"
                      placeholder="$USD per hour"
                      disabled={this.props.parent.selectedCourse == ""}
                      onChange={this.update} />
        </div>
              )
    }
  })

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

  CourseList = React.createClass({
    editCourse: function(course){
      courseBox = this.props.parent
      courseId = course.id

      busy = function(){
        courseBox.setState({
          busy: true
        })
      }

      unbusy = function(){
        courseBox.setState({
            busy: false
        })
      }

      showFailureMessage = function(){
        unbusy()
        courseBox.error("GenericError")
      }

      if(courseBox.state.busy){ // PREVENTS SIMULTANEOUS MULTIPLE REQUESTS
        courseBox.error("BusyWithAddRequest");
        return
      }

      swal({
        title: "Adjust your rate for " + course.subject_name + " " + course.call_number,
        type: "input",
        showCancelButton: true,
        closeOnConfirm: false,
        inputPlaceholder: "Hourly rate"
      }, function(newRate){
        if (isPositiveInteger(newRate) && newRate !== "") {
          sendEditCourseRequest = function(data){
            if(courseBox.state.busy) return
            busy()
            tutorCourseId = data[0].id
            endpoint = API_LOCATION + '/tutor_courses/' + tutorCourseId
            editCourseRequest = $.ajax({
              url: endpoint,
              data: { new_rate: newRate },
              type: "PATCH",
              success: function(data){
                courseBox.getCourses()
                swal({
                  title: "Success!\n\nYour new rate for " + course.subject_name + " " + course.call_number + " is $" + data.rate + "/hour.",
                  timer: 2000,
                  type: 'success'
                })
                unbusy()
              },
              error: showFailureMessage
            })
          }

          endpoint = API_LOCATION + '/tutor_courses/find'
          findTutorCourse = $.post(endpoint, {
            tutor_id: courseBox.props.tutor_id,
            course_id: courseId
          })
          findTutorCourse.success(sendEditCourseRequest)
          findTutorCourse.fail(showFailureMessage)
          swal.close()
          return true
        } else {
          swal.showInputError("Your rate must be a positive integer.")
          return false
        };
      }, function(){
        unbusy()
      })
    },
    removeCourse: function(course){
        // TODO: add logic removing a course
        courseBox = this.props.parent
        courseId = course.id

        busy = function(){
          courseBox.setState({
            busy: true
          })
        }

        unbusy = function(){
          courseBox.setState({
              busy: false
          })
        }

        showFailureMessage = function(){
          unbusy()
          courseBox.error("GenericError")
        }

        if(courseBox.state.busy){ // PREVENTS SIMULTANEOUS MULTIPLE REQUESTS
          courseBox.error("BusyWithAddRequest");
          return
        }

        swal({
          title: "Are you sure you want to delete " + course.subject_name + " " + course.call_number + "?",
          type: "warning",
          showCancelButton: true,
          confirmButtonColor: "#DD6B55",
          confirmButtonText: "Yes, remove it!",
          cancelButtonText: "Cancel",
          closeOnConfirm: false,
        }, function(isConfirm){
          if (isConfirm) {
            sendRemoveCourseRequest = function(data){
              if(courseBox.state.busy) return
              busy()
              tutorCourseId = data[0].id
              endpoint = API_LOCATION + '/tutor_courses/' + tutorCourseId
              removeCourseRequest = $.ajax({
                url: endpoint,
                type: "DELETE",
                success: function(data){
                  courseBox.getCourses()
                  swal({
                    title: "Removed " + course.subject_name + " " + course.call_number + " from your course list.",
                    timer: 2000,
                    type: 'success'
                  })
                  unbusy()
                },
                error: showFailureMessage
              })
            }

            endpoint = API_LOCATION + '/tutor_courses/find'
            findTutorCourse = $.post(endpoint, {
              tutor_id: courseBox.props.tutor_id,
              course_id: courseId
            })
            findTutorCourse.success(sendRemoveCourseRequest)
            findTutorCourse.fail(showFailureMessage)
            swal.close()
            return true
          } else {
            unbusy()
            return false
          };
        })
    },
    render: function(){
      courseList = this
      courses = this.props.parent.state.courses
      if (courses.length > 0){
        return (<table style={{"display" : "inline-block"}}>
                <thead>
                  <tr>
                    <td width="400">School</td>
                    <td width="150">Subject</td>
                    <td width="150">Call Number</td>
                    <td width="400">Course Name</td>
                    <td>Rate</td>
                    <td>Actions</td>
                  </tr>
                </thead>
                <tbody>
                {
                  courses.map(function(course){
                    return (
                      <tr className="courselistitem">
                        <td>{course.school_name}</td>
                        <td>{course.subject_name}</td>
                        <td>{course.call_number}</td>
                        <td><b>{course.friendly_name}</b></td>
                        <td>${course.rate}/hr</td>
                        <td>
                        <a onClick={function(){
                          courseList.editCourse(course)
                        }}>Edit</a>&nbsp;
                        <a onClick={function(){
                          courseList.removeCourse(course)
                        }}>Remove</a>
                        </td>
                      </tr>
                          )
                  })
                }
                </tbody>
              </table>)
      } else {
        return (
          <div style={
            {
                "display"      : "inline-block",
                "width"        : "100%",
                "textAlign"    : "center",
                "padding"      : "50px",
                "marginBottom" : "20px",
                "color"        : "darkgray",
                "border"       : "1px solid lightgray",
                "borderRadius" : "3px"
            }
          }>No Courses</div>
        )
      }
    }
  })
})()