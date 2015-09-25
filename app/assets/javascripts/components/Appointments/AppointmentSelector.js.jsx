var AppointmentSelector = React.createClass({
  getInitialState: function () {
      return {
          selectedSlots: [],
          selectedSubject: this.props.subject || {},
          disabledSlots: [],
          currentStep: 1
      };
  },
  handleSubject: function (newSubject) {
    this.setState({ selectedSubject: newSubject });
  },
  handleSlots: function (newSlots) {
    newSlots.unique((slot) => slot.start_time);
    this.setState({ selectedSlots: newSlots });
  },
  handleSteps: function (newStep) {
    this.setState({ currentStep: newStep });
  },
  handleDisabledSlots: function (newDisabledSlots) {
    newDisabledSlots.unique((slot) => slot.start_time);
    this.setState({ disabledSlots: newDisabledSlots })
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
                                   />
      case 2: return <PaymentForm {...this.props} />
      case 3: return <ConfirmationScreen {...this.props} />
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
                    <a className="btn" onClick={function(){
                      if (this.state.currentStep > 1) {
                        this.setState({
                          currentStep: this.state.currentStep - 1
                        })
                      };
                    }.bind(this)}><span className="fi-arrow-left"></span> Go back</a>
                    <a className="btn" onClick={function(){
                      if (this.state.selectedSlots.length > 0) {
                        this.setState({
                          currentStep: this.state.currentStep + 1
                        })
                      };
                    }.bind(this)}>Next <span className="fi-arrow-right"></span></a>
                  </div>
                </footer>
          </div>
        </section>
      </div>
    );
  }
});