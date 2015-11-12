var SubjectSelector = React.createClass({
  componentDidMount: function () {
      this.fetchSubjects()
      navBar = this.props.UINavigationBarDelegate;
      navBar.canGoForward = true;
      navBar.canShowForwardButton = false;
      navBar.canGoBack = false;
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

        if (!this.props.forceSubject && passedInSubject) {
          this.props.handleSubject(passedInSubject);
        }
      }.bind(this)
    );
  },
  handleClick: function (subject) {
    newSubject = this.state.availableSubjects.find(
      (potentialSubject) => potentialSubject.id == subject.id
    );
    if (newSubject) {
      this.props.handleSubject(newSubject);
    } else {
      console.error("No subject found for ID = " + subject.id);
    }
  },
  getBackground: function (subject) {
    var background = ["subject-item"];
    if(this.props.selectedSubject.id == subject.id) {
      background.push("active");
    } else {
      background.push("neutral");
    }
    return background.join(" ");
  },
  render: function () {
    return (
      <div className="main-view">
        <div className="prompt">Select a course below.</div>
        <div className="subject-selector">{
            this.state.availableSubjects.map(function(subject){
              return (
                <div className={this.getBackground(subject)} onClick={this.handleClick.bind(this, subject)}>
                  <span className="name">{subject.course_name}</span>
                  <span className="rate">${subject.rate}/hr</span>
                </div>
              );
            }.bind(this))
          }</div>
      </div>
    );
  }
});