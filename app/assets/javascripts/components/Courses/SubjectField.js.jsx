SubjectField = React.createClass({
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
        <select name="course[subject_id]" defaultValue="Course" disabled={this.state.all_subjects.length < 1} onChange={this.props.update} >
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