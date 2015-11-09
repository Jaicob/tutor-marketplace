var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var AppointmentSelector = React.createClass({
  displayName: "AppointmentSelector",

  getInitialState: function () {
    return {
      selectedSlots: [],
      selectedSubject: this.props.subject || {},
      disabledSlots: [],
      currentStep: 1,
      forceFetch: false,
      student: {},
      token: "",
      customer_id: ""
    };
  },
  componentDidMount: function () {
    this.fetchStudent();
  },
  handleSubject: function (newSubject) {
    this.setState({ selectedSubject: newSubject });
  },
  handleSlots: function (newSlots) {
    newSlots.unique(function (slot) {
      return slot.start_time;
    });
    this.setState({
      selectedSlots: newSlots,
      forceFetch: false
    });
  },
  handleSteps: function (newStep) {
    this.setState({ currentStep: newStep });
  },
  handleDisabledSlots: function (newDisabledSlots) {
    newDisabledSlots.unique(function (slot) {
      return slot.start_time;
    });
    this.setState({ disabledSlots: newDisabledSlots });
  },
  handleBackStep: function () {
    if (this.state.currentStep > 1) {
      this.setState({
        currentStep: this.state.currentStep - 1,
        forceFetch: true
      });
    }
  },
  handleNextStep: function () {
    if (this.state.selectedSlots.length > 0) {
      this.setState({
        currentStep: this.state.currentStep + 1
      });
    };
  },
  canGoBack: function () {
    switch (this.state.currentStep) {
      case 1:
        return false;
      default:
        return true;
    }
  },
  canGoForward: function () {
    switch (this.state.currentStep) {
      case 1:
        return this.state.selectedSlots.length > 0;
      default:
        return true;
    }
  },
  fetchStudent: function () {
    var endpoint = API.endpoints.students();
    $.getJSON(endpoint, (function (data) {
      this.setState({
        student: data
      });
    }).bind(this));
  },
  handleCard: function (customer_id, token) {
    if (customer_id == null) {
      this.setState({ token: token });
    } else {
      this.setState({ customer_id: customer_id });
    };
  },
  renderSubjectSelector: function () {
    if (this.state.currentStep == 1) {
      return React.createElement(SubjectSelector, { tutor: this.props.tutor,
        selectedSubject: this.state.selectedSubject,
        handleSubject: this.handleSubject
      });
    };
  },
  renderMainView: function () {
    switch (this.state.currentStep) {
      case 1:
        return React.createElement(SlotSelector, { tutor: this.props.tutor,
          selectedSlots: this.state.selectedSlots,
          handleSlots: this.handleSlots,
          disabledSlots: this.state.disabledSlots,
          handleDisabledSlots: this.handleDisabledSlots,
          forceFetch: this.state.forceFetch
        });
      case 2:
        return React.createElement(PaymentForm, _extends({}, this.props, { currentStudent: this.state.student, onChange: this.handleCard }));
      case 3:
        return React.createElement(ConfirmationScreen, this.props);
      case 4:
        return React.createElement(Summary, this.props);
      default:
        break;
    };
  },
  render: function () {
    // <div className="column selected-class-output">
    // </div>
    return React.createElement(
      "section",
      { className: "availability", id: "book" },
      React.createElement(
        "div",
        { className: "wrapper" },
        React.createElement(
          "article",
          { className: "availability-calendar" },
          React.createElement(
            "header",
            { className: "row" },
            React.createElement(
              "h3",
              { className: "title" },
              "Availability"
            ),
            this.renderSubjectSelector()
          ),
          this.renderMainView()
        ),
        React.createElement(
          "footer",
          { className: "row" },
          React.createElement(
            "div",
            { className: "column submit" },
            this.canGoBack() && React.createElement(
              "a",
              { className: "btn", onClick: this.handleBackStep },
              React.createElement("span", { className: "fi-arrow-left" }),
              " Go back"
            ),
            this.canGoForward() && React.createElement(
              "a",
              { className: "btn", onClick: this.handleNextStep },
              "Next ",
              React.createElement("span", { className: "fi-arrow-right" })
            )
          )
        )
      )
    );
  }
});