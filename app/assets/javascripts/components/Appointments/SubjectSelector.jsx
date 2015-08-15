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
    this.props.handleSubject(subject)
  },
  render: function () {
    return (
      <div className="appointment-selector__header__subject-selector">
        {
          this.state.availableSubjects.map(function(subject){
            return <Subject subject={subject}
                            selectedSubject={this.props.selectedSubject}
                            handleClick={this.handleClick}
                            />
          }.bind(this))
        }
      </div>
    );
  }
});