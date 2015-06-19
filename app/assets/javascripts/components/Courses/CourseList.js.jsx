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
        title: "Are you sure you want to remove " + course.subject_name + " " + course.call_number + " from your course list?",
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