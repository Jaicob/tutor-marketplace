var Delegate = function () {
  this.refresh = function () {
    this.backButtonText = null;
    this.backButtonClick = null;
    this.canGoBack = null;
    this.canShowBackButton = null;

    this.forwardButtonText = null;
    this.forwardButtonClick = null;
    this.canGoForward = null;
    this.canShowForwardButton = null;

    this.description = null;
    this.extra_buttons = null;
  }.bind(this);

  this.refresh();
}

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
          customer_id: "",
          UINavigationBarDelegate: new Delegate()
      };
  },
  componentDidMount: function() {
    this.fetchStudent();
  },
  updateDelegate: function (del) {
    this.setState({
      UINavigationBarDelegate: del
    });
  },
  handleSubject: function (newSubject) {
    this.setState({
      selectedSubject: newSubject,
      forceSubject: true
    });
    this.handleNextStep();
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
    if (this.canGoBack()) {
      var goBack = function () {
        this.setState({
          currentStep: this.state.currentStep - 1,
          forceFetch: true
        })
        this.state.UINavigationBarDelegate.refresh();
      }.bind(this);

      if(this.state.UINavigationBarDelegate.backButtonClick != null) {
        this.state.UINavigationBarDelegate.backButtonClick(goBack);
      } else {
        goBack();
      }
    }
  },
  handleNextStep: function () {
    if (this.canGoForward()) {
      var goForward = function () {
        this.setState({
          currentStep: this.state.currentStep + 1,
          forceFetch: true
        })
        this.state.UINavigationBarDelegate.refresh();
      }.bind(this);

      if(this.state.UINavigationBarDelegate.forwardButtonClick != null) {
        this.state.UINavigationBarDelegate.forwardButtonClick(goForward);
      } else {
        goForward();
      }
    }
  },
  canGoBack: function () {
    if (this.state.UINavigationBarDelegate.canGoBack != null) {return this.state.UINavigationBarDelegate.canGoBack};
    switch(this.state.currentStep) {
      case 1: return false
      default: return true
    }
  },
  canGoForward: function () {
    if (this.state.UINavigationBarDelegate.canGoForward != null) {return this.state.UINavigationBarDelegate.canGoForward};
    switch(this.state.currentStep) {
      case 1: return true
      case 2: return this.state.selectedSlots.length > 0
      default: return true
    }
  },
  canShowBackButton: function () {
    if (this.state.UINavigationBarDelegate.canShowBackButton != null) { return this.state.UINavigationBarDelegate.canShowBackButton };
    return this.canGoBack();
  },
  canShowForwardButton: function () {
    if (this.state.UINavigationBarDelegate.canShowForwardButton != null) { return this.state.UINavigationBarDelegate.canShowForwardButton };
    return this.canGoForward();
  },
  canShowDescription: function () {
    if(this.state.UINavigationBarDelegate.description != null) { return this.state.UINavigationBarDelegate.description }
    return false;
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
  renderMainView: function () {
    switch(this.state.currentStep){
      case 1:
              return <SubjectSelector tutor={this.props.tutor}
                                      selectedSubject={this.state.selectedSubject}
                                      handleSubject={this.handleSubject}
                                      forceSubject={this.state.forceSubject}
                                      UINavigationBarDelegate={this.state.UINavigationBarDelegate}
                                      updateDelegate={this.updateDelegate}
                                       />
      case 2:
              return <SlotSelector tutor={this.props.tutor}
                                   selectedSlots={this.state.selectedSlots}
                                   handleSlots={this.handleSlots}
                                   disabledSlots={this.state.disabledSlots}
                                   handleDisabledSlots={this.handleDisabledSlots}
                                   forceFetch={this.state.forceFetch}
                                   UINavigationBarDelegate={this.state.UINavigationBarDelegate}
                                   updateDelegate={this.updateDelegate}
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
            { this.canShowBackButton() &&
            <a className="back btn" onClick={this.handleBackStep}>
              {this.state.UINavigationBarDelegate.backButtonText || "Go Back"}
            </a>
            }
            {
              (
                this.canShowForwardButton() &&
                <a className="forward btn" onClick={this.handleNextStep}>
                  {this.state.UINavigationBarDelegate.forwardButtonText || "Next"}
                </a>
              ) ||
              (
                <div className="spacer"> </div>
              )
            }
            {
              this.canShowDescription() &&
              <p className="description">{this.state.UINavigationBarDelegate.description || ""}</p>
            }
            {
              this.state.UINavigationBarDelegate.extra_buttons && this.state.UINavigationBarDelegate.extra_buttons.map(function(extra) {
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