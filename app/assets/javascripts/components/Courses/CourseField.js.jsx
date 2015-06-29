CourseField = React.createClass({
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
        <select name="course[course_id]" defaultValue="Course" disabled={this.state.all_courses.length < 1} onChange={this.props.update}>
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