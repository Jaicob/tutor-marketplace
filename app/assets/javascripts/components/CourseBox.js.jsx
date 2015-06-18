API_LOCATION = "http://localhost:3000"

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
        console.log("BusyWithAddRequest!");
      }
      errors.CourseAlreadyAdded = function(){
        console.log("CourseAlreadyAdded!");
      }
      errors.InvalidCourseRate = function(){
        console.log("InvalidCourseRate!");
      }
      errors.NoCourseSelected = function(){
        console.log("NoCourseSelected!");
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
        <select name="course[school_id]" onChange={this.update}>
          <option selected="true" disabled="true">School</option>
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
        <select name="course[subject_id]" disabled={this.state.all_subjects.length < 1} onChange={this.update} >
          <option selected="true" disabled="true">Subject</option>
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
    if(nextProps.school && nextProps.subject){
      url = API_LOCATION + '/courses?school_id=' + nextProps.school + '&subject_id=' + nextProps.subject
      $.get(url, function(data){
        this.setState({
          all_courses: data
        });
      }.bind(this));
    } else{
      this.setState({
        all_courses: []
      })
    }
  },
  render: function(){
    return (
      <div className="medium-3 columns">
        <select name="course[course_id]" disabled={this.state.all_courses.length < 1} onChange={this.update}>
          <option selected="true" disabled="true">Course</option>
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
  handleClick: function(){
    courseBox = this.props.parent
    savedCourses = courseBox.state.courses
    currentCourseId = courseBox.state.selectedCourse
    currentCourseRate = courseBox.state.selectedRate
    noDuplicates = savedCourses.filter(function(course){
      return course.id == currentCourseId
    }).length == 0

    if(courseBox.state.busy){
      courseBox.error("BusyWithAddRequest");
    } else if(!currentCourseId){
      courseBox.error("NoCourseSelected")
    } else if(parseInt(currentCourseRate) == NaN){
      courseBox.error("InvalidCourseRate")
    } else if(noDuplicates){
        courseBox.setState({
          busy: true
        })
        $.get(API_LOCATION + '/courses?id=' + currentCourseId, function(data){
          data[0]["rate"] = currentCourseRate
          courses = savedCourses.concat(data)
          courseBox.setState({
            courses: courses,
            busy: false
          })
        })
    } else{
      courseBox.error("CourseAlreadyAdded")
    }
  },
  render: function(){
    style = {
      "margin-right" : "15px"
    }
    return <input type="submit" name="commit" value="Add course" className="button radius success small right" style={style} onClick={this.handleClick} />
  }
})

CourseList = React.createClass({
  render: function(){
    return <div className="courselist">
            <table>
              <thead>
                <tr>
                  <td>School</td>
                  <td>Subject</td>
                  <td>Call Number</td>
                  <td>Title</td>
                  <td>Rate</td>
                </tr>
              </thead>
              <tbody>
              {
                this.props.parent.state.courses.map(function(course){
                  return (
                    <tr className="courselistitem">
                      <td>{course.school_name}</td>
                      <td>{course.subject_name}</td>
                      <td>{course.call_number}</td>
                      <td><b>{course.friendly_name}</b></td>
                      <td>${course.rate}/hr</td>
                    </tr>
                        )
                })
              }
              </tbody>
            </table>
          </div>
  }
})