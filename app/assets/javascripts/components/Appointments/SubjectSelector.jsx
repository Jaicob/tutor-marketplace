var SubjectSelector = React.createClass({
  componentDidMount: function () {
      this.fetchSubjects()
  },
  getInitialState: function () {
    return {
      availableSubjects: []
    };
  },
  fetchSubjects: function () {
    var endpoint = API.endpoints.tutor.courses({
      tutor_id: this.props.tutor
    });

    $.getJSON(endpoint, function (data) {
        this.setState({
          availableSubjects: data
        });

        var passedInSubject = this.state.availableSubjects.find(
          (subject) => subject.course_id == getSearchQueryVariable("course")
        );
        if (this.props.selectedSubject || passedInSubject) {
          this.props.handleSubject(this.props.selectedSubject || passedInSubject);
        }
      }.bind(this)
    );
  },
  handleClick: function (subject) {
    newSubject = this.state.availableSubjects.find(
      (potentialSubject) => potentialSubject.id == subject.target.value
    );
    this.props.handleSubject(newSubject);
  },
  render: function () {
    return (
      <div className="dropdown--subject">
        <label for="select-subject">Course:</label>
        <div className="select-wrapper">
          <select id="select-subject" className="select-menu" onChange={this.handleClick}>
            <optgroup label="Available Courses">
              {
                this.state.availableSubjects.map(function(subject){
                  return <Subject subject={subject} selectedSubject={this.props.selectedSubject} />
                }.bind(this))
              }
            </optgroup>
          </select>
        </div>
      </div>
    );
  }
});