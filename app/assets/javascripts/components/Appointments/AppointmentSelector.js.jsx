var AppointmentSelector = React.createClass({
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
  componentDidMount: function() {
    this.fetchStudent();
  },
  handleSubject: function (newSubject) {
    this.setState({ selectedSubject: newSubject });
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
    switch(this.state.currentStep) {
      case 1: return false
      default: return true
    }
  },
  canGoForward: function () {
    switch(this.state.currentStep) {
      case 1: return this.state.selectedSlots.length > 0
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
  renderSubjectSelector: function () {
    if (this.state.currentStep == 1) {
      return <SubjectSelector tutor={this.props.tutor}
                              selectedSubject={this.state.selectedSubject}
                              handleSubject={this.handleSubject}
                              />
    };
  },
  renderMainView: function () {
    switch(this.state.currentStep){
      case 1:
              return <SlotSelector tutor={this.props.tutor}
                                   selectedSlots={this.state.selectedSlots}
                                   handleSlots={this.handleSlots}
                                   disabledSlots={this.state.disabledSlots}
                                   handleDisabledSlots={this.handleDisabledSlots}
                                   forceFetch={this.state.forceFetch}
                                   />
      case 2: return <PaymentForm {...this.props} currentStudent={this.state.student} onChange={this.handleCard} />
      case 3: return <ConfirmationScreen {...this.props} />
      case 4: return <Summary {...this.props} />
      default: break
    };
  },
  render: function(){
    return (
      <div>
        <section className="availability">
          <div className="wrapper">
            <article className="availability-calendar">
              <header className="row">
                <h3 className="title">Availability</h3>
                  {this.renderSubjectSelector()}
              </header>
              {this.renderMainView()}
            </article>
            <footer className="row">
                  <div className="column selected-class-output">
                    <p>Selected Date will show here.</p>
                    <p>Selected Class will show here.</p>
                  </div>
                  <div className="column submit">
                    { this.canGoBack() ? <a className="btn" onClick={this.handleBackStep}><span className="fi-arrow-left"></span> Go back</a> : ""}
                    { this.canGoForward() ? <a className="btn" onClick={this.handleNextStep}>Next <span className="fi-arrow-right"></span></a> : ""}
                  </div>
                </footer>
          </div>
        </section>
      </div>
    );
  }
});