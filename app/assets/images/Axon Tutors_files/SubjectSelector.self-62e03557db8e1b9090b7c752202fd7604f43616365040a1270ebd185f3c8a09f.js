var SubjectSelector = React.createClass({
  displayName: "SubjectSelector",

  componentDidMount: function () {
    this.fetchSubjects();
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

    $.getJSON(endpoint, (function (data) {
      this.setState({
        availableSubjects: data
      });

      var passedInSubject = this.state.availableSubjects.find(function (subject) {
        return subject.course_id == getSearchQueryVariable("course");
      });
      if (this.props.selectedSubject || passedInSubject) {
        this.props.handleSubject(this.props.selectedSubject || passedInSubject);
      }
    }).bind(this));
  },
  handleClick: function (subject) {
    newSubject = this.state.availableSubjects.find(function (potentialSubject) {
      return potentialSubject.id == subject.target.value;
    });
    this.props.handleSubject(newSubject);
  },
  render: function () {
    return React.createElement(
      "div",
      { className: "dropdown--subject" },
      React.createElement(
        "label",
        { "for": "select-subject" },
        "Course:"
      ),
      React.createElement(
        "div",
        { className: "select-wrapper" },
        React.createElement(
          "select",
          { id: "select-subject", className: "select-menu", onChange: this.handleClick },
          React.createElement(
            "optgroup",
            { label: "Available Courses" },
            this.state.availableSubjects.map((function (subject) {
              return React.createElement(Subject, { subject: subject, selectedSubject: this.props.selectedSubject });
            }).bind(this))
          )
        )
      )
    );
  }
});