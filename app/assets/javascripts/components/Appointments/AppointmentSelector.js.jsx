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

    this.titleBarText = null;
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
          selectedLocation: "",
          disabledSlots: [],
          currentStep: 1,
          totalCharge: 0,
          forceSubject: false,
          forceFetch: false,
          student: {},
          promo: null,
          token: "",
          customer: "",
          appointments: [],
          UINavigationBarDelegate: new Delegate()
      };
  },
  componentWillMount: function () {
    var self = this;
    this.delegation = {
      UINavigationBarDelegate: self.state.UINavigationBarDelegate,
      updateDelegate: self.updateDelegate
    }
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
  handleLocation: function (newLocation) {
    this.setState({
      selectedLocation: newLocation
    });
  },
  handleSteps: function (newStep) {
    this.setState({ currentStep: newStep });
  },
  handleDisabledSlots: function (newDisabledSlots) {
    newDisabledSlots.unique((slot) => slot.start_time);
    this.setState({ disabledSlots: newDisabledSlots })
  },
  handlePromo: function (newPromo) {
    this.setState({promo: newPromo});
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
    var endpoint = API.endpoints.students({
      student_id: this.props.student
    });
    $.getJSON(endpoint, function (data) {
      if (data.success) {
        data['id'] = this.props.student;
        this.setState({
          student: data
        });
      };
    }.bind(this));
  },
  handleCard: function(customer, token) {
    if (customer == null) {
      this.setState({token: token})
    } else {
      this.setState({customer: customer})
    };
  },
  handleTotal: function (newTotal) {
    this.setState({
      totalCharge: newTotal
    });
  },
  makeAppointment: function (update) {
    if (Object.keys(this.state.student).length > 0) {
      var endpoint = API.endpoints.appointment.create({ "student_id": this.state.student.id });
    } else {
      var endpoint = API.endpoints.appointment.create_visitor();
    }

    var appointments = this.state.selectedSlots.map(function(slot){
      return {
        slot_id: slot.id,
        course_id: this.state.selectedSubject.course_id,
        start_time: slot.start_time
      };
    }.bind(this));

    var callback = function (data) {
      this.setState({ appointments: data });
      update();
    }.bind(this);

    $.post(endpoint, { data: appointments }, callback);
  },
  renderMainView: function () {
    switch(this.state.currentStep){
      case 1:
              return <SubjectSelector
                      {...this.props}
                      {...this.delegation}
                      selectedSubject={this.state.selectedSubject}
                      handleSubject={this.handleSubject}
                      forceSubject={this.state.forceSubject}
                     />
      case 2:
              return <SlotSelector
                        {...this.props}
                        {...this.delegation}
                        selectedSubject={this.state.selectedSubject}
                        selectedSlots={this.state.selectedSlots}
                        disabledSlots={this.state.disabledSlots}
                        forceFetch={this.state.forceFetch}
                        handleSlots={this.handleSlots}
                        handleDisabledSlots={this.handleDisabledSlots}
                      />
      case 3: return <LocationSelector
                       {...this.props}
                       {...this.delegation}
                       selectedLocation={this.state.selectedLocation}
                       handleLocation={this.handleLocation}
                       makeAppointment={this.makeAppointment}
                     />
      case 4: return <Checkout
                        {...this.props}
                        {...this.delegation}
                        selectedSlots={this.state.selectedSlots}
                        selectedSubject={this.state.selectedSubject}
                        currentStudent={this.state.student}
                        total={this.state.totalCharge}
                        promo={this.state.promo}
                        handlePromo={this.handlePromo}
                        handleTotal={this.handleTotal}
                        onChange={this.handleCard}
                     />
      case 5: return <PaymentForm
                        {...this.props}
                        {...this.delegation}
                        currentStudent={this.state.student}
                        total={this.state.totalCharge}
                        onChange={this.handleCard}
                      />
      case 6: return <Receipt
                      {...this.props}
                      {...this.state}
                      {...this.delegation}
                      total={this.state.totalCharge}
                     />
      default: break
    };
  },
  render: function(){
    return (
      <div className="appointment-selector" id="book">
        <article className="availability-calendar">
          <div className="header row">{
            this.state.UINavigationBarDelegate.titleBarText || "Book " + this.props.tutor_name
          }</div>
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