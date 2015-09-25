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
    this.setState({
      availableSubjects: [
        {
          "name": "intro to calculus",
          "id": 23,
          "rate": 25,
        },
        {
          "name": "advanced biology",
          "id": 24,
          "rate": 35,
        }
      ]
    });

    // var endpoint = API.endpoints.courses({
    //   tutor_id: this.props.tutor
    // });

    // $.getJSON(endpoint, function (data) {
    //   this.setState({
    //     availableSubjects: data
    //   });
    // });
  },
  handleClick: function (subject) {
    newSubject = this.state.availableSubjects.filter(
      (potentialSubject) => potentialSubject.id == subject.target.value
    )[0]
    this.props.handleSubject(newSubject)
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
                  return <Subject subject={subject}
                                  selectedSubject={this.props.selectedSubject}
                                  />
                }.bind(this))
              }
            </optgroup>
          </select>
        </div>
      </div>
    );
  }
});