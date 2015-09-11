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
      case 1: return <SlotSelector tutor={this.props.tutor}
                                   selectedSlots={this.state.selectedSlots}
                                   handleSlots={this.handleSlots}
                                   disabledSlots={this.state.disabledSlots}
                                   handleDisabledSlots={this.handleDisabledSlots}
                                   />
      default: break
    };
  },
  render: function(){
    return (
      <div>
        <div className="appointment-selector__header">
          {this.renderSubjectSelector()}
        </div>
        <div className="appointment-selector__main-view">
          {this.renderMainView()}
        </div>
        <TabBar tutor={this.props.tutor}
                slots={this.state.selectedSlots}
                subject={this.state.selectedSubject}
                step={this.state.currentStep}
                handleSteps={this.handleSteps}
                />
      </div>
    );
  }
});