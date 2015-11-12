var AppointmentSelector = React.createClass({
  getInitialState: function () {
      return {
          selectedSlots: [],
          selectedSubject: this.props.subject || {},
          disabledSlots: [],
          currentStep: 1,
          forceSubject: false,
          forceFetch: false,
          student: {},
          token: "",
          customer_id: ""
      };
  },
  componentDidMount: function() {
    this.fetchStudent();
  },
  handleSubject: function (newSubject) {
    this.setState({
      selectedSubject: newSubject,
      currentStep: this.state.currentStep + 1,
      forceSubject: true
    });
  },
  handleSlots: function (newSlots) {
    newSlots.unique((slot) => slot.start_time);
    this.setState({
      selectedSlots: newSlots,
      forceFetch: false
    });
  },
  handleSteps: function (newStep) {
    this.setState({ currentStep: newStep });
  },
  handleDisabledSlots: function (newDisabledSlots) {
    newDisabledSlots.unique((slot) => slot.start_time);
    this.setState({ disabledSlots: newDisabledSlots })
  },
  handleBackStep: function () {
    if (this.state.currentStep > 1) {
      this.setState({
        currentStep: this.state.currentStep - 1,
        forceFetch: true
      })
    }
  },
  handleNextStep: function () {
    if (this.state.selectedSlots.length > 0) {
      this.setState({
        currentStep: this.state.currentStep + 1
      })
    };
  },
  canGoBack: function () {
    if (this.delegates().canGoBack != null) {return this.delegates().canGoBack};
    switch(this.state.currentStep) {
      case 1: return false
      default: return true
    }
  },
  canGoForward: function () {
    if (this.delegates().canGoForward != null) {return this.delegates().canGoForward};
    switch(this.state.currentStep) {
      case 1: return true
      case 2: return this.state.selectedSlots.length > 0
      default: return true
    }
  },
  fetchStudent: function () {
    var endpoint = API.endpoints.students();
    $.getJSON(endpoint, function (data) {
      this.setState({
        student: data
      });
    }.bind(this));
  },
  handleCard: function(customer_id, token) {
    if (customer_id == null) {
      this.setState({token: token})
    } else {
      this.setState({customer_id: customer_id})
    };
  },
  delegates: function () {
    var component = this;
    var state = this.state;
    return {
      backButtonText: state.backButtonText || "",
      backButtonClick: state.backButtonClick || null,
      canGoBack: state.canGoBack || null,
      forwardButtonText: state.forwardButtonText || "",
      forwardButtonClick: state.forwardButtonClick || null,
      canGoForward: state.canGoForward || null,
      extra_buttons: state.extra_buttons || [],
      send: function () {
        this.setState(this.delegates);
      }.bind(component)
    }
  },
  renderMainView: function () {
    switch(this.state.currentStep){
      case 1:
              return <SubjectSelector tutor={this.props.tutor}
                                      selectedSubject={this.state.selectedSubject}
                                      handleSubject={this.handleSubject}
                                      forceSubject={this.state.forceSubject}
                                      delegates={this.delegates()}
                                       />
      case 2:
              return <SlotSelector tutor={this.props.tutor}
                                   selectedSlots={this.state.selectedSlots}
                                   handleSlots={this.handleSlots}
                                   disabledSlots={this.state.disabledSlots}
                                   handleDisabledSlots={this.handleDisabledSlots}
                                   forceFetch={this.state.forceFetch}
                                   />
      case 3: return <PaymentForm {...this.props} currentStudent={this.state.student} onChange={this.handleCard} />
      case 4: return <ConfirmationScreen {...this.props} />
      case 5: return <Summary {...this.props} />
      default: break
    };
  },
  render: function(){
    // <div className="column selected-class-output">
    // </div>
    return (
      <div className="appointment-selector" id="book">
        <article className="availability-calendar">
          <div className="header row">Book Me Now</div>
          {this.renderMainView()}
        </article>
        <div className="footer row">
            { this.canGoBack() &&
            <a className="back btn" onClick={this.handleBackStep}>
              {this.delegates().backButtonText || "Go Back"}
            </a>
            }
            { this.canGoForward() &&
            <a className="forward btn" onClick={this.handleNextStep}>
              {this.delegates().forwardButtonText || "Next"}
            </a>
            }
            {
              this.delegates().extra_buttons.map(function(extra) {
                return(
                  <a className={extra.classes || "btn"} onClick={extra.action}>
                    {extra.text}
                  </a>
                );
              })
            }
        </div>
      </div>
    );
  }
});