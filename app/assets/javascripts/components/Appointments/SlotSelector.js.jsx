var SlotSelector = React.createClass({
  rangeDistance: 7,
  rangeUnit: 'days',
  getInitialState: function () {
    return {
        allSlots: [],
        startRange: moment(),
        endRange:   moment().add(this.rangeDistance - 1, this.rangeUnit)
    };
  },
  setDelegates: function (newLength) {
    if (newLength == undefined) {
      newLength = this.props.selectedSlots.length;
    };
    navBar = this.props.UINavigationBarDelegate;
    navBar.titleBarText = "Book " + this.props.tutor_name + " for " + this.props.selectedSubject.course_number;
    navBar.forwardButtonText = "Set Location";
    navBar.backButtonText = "Change Subject";

    // if(newLength == 1) {
    //   navBar.description = newLength + " session selected.";
    // } else if (newLength < 1) {
    //   navBar.description = null;
    // } else {
    //   navBar.description = newLength + " sessions selected.";
    // }

    this.props.updateDelegate(navBar);
  },
  componentWillMount: function () {
    this.setDelegates();
  },
  componentDidMount: function () {
    this.componentWillReceiveProps(this.props);
  },
  componentWillReceiveProps: function (nextProps) {
    if((nextProps.disabledSlots.length == 0 && nextProps.selectedSlots.length == 0) || nextProps.forceFetch) {
      this.fetchSlots(nextProps.tutor);
    }

    if (this.props.selectedSlots.length != nextProps.selectedSlots.length) this.setDelegates();
  },
  // [ ] TODO (AJ) Refactor this later
  fetchSlots: function (tutor) {
    var endpoint = API.endpoints.tutor_slots.get({
      tutor_id: tutor
    });

    var request = $.getJSON(endpoint);

    request.success(function(data){
      if ((this.props.disabledSlots.length == 0 && this.props.selectedSlots.length == 0) || this.props.forceFetch) {
        this.setState({
          allSlots: this.parseData(data)
        });

        if (this.props.forceFetch) {
          var disabledSlots = this.getDisabledSlots(this.props.selectedSlots);
          this.props.handleDisabledSlots(disabledSlots);
        };
      }
    }.bind(this));
  },
  parseData: function (data) {
    appointmentCandidates = this.getAppointmentCandidates(data);
    parsedData = this.groupAppointmentCandidates(appointmentCandidates);
    return parsedData;
  },
  getAppointmentCandidates: function (slots) {
      slots = slots.map(function(slot){
        var startTimeOfSlot = moment(slot.start_time);
        var endTimeOfSlot = moment(startTimeOfSlot).add(slot.duration, 's');
        var rangeTimeOfSlot = moment.range(startTimeOfSlot, endTimeOfSlot);

        var minutesChecked = 0;
        var allStartTimesForSlot = [];
        rangeTimeOfSlot.by('minutes', function(moment) {
          if (moment.minutes() % 30 == 0) { // checks if starting at either a half hour or a full hour
            var dividedSlot = $.extend({}, slot);
            dividedSlot.start_time = moment.format();
            dividedSlot.duration = 3600;
            allStartTimesForSlot.push(dividedSlot);
          }
          minutesChecked += 1;
        });

        if (allStartTimesForSlot.length > 2) {
          allStartTimesForSlot.pop()
          allStartTimesForSlot.pop()
          return allStartTimesForSlot;
        } else {
          return allStartTimesForSlot;
        }
      });

      if (slots.length < 1) {
        console.log("not enough slot times");
      } else {
        slots = slots.reduce(function(a, b){
          Array.prototype.push.apply(a, b);
          return a;
        });
      }

      return slots;
  },
  groupAppointmentCandidates: function (slots) {
    var newSlots = {}
    for (var slot = 0; slot < slots.length; slot++) {
      var date = moment(slots[slot].start_time).format("MM-DD-YYYY")
      if (newSlots[date]) {
        newSlots[date].push(slots[slot])
      } else {
        newSlots[date] = [slots[slot]];
      }
    }
    return newSlots
  },
  handleNextRange: function () {
    this.setState({
      startRange: this.state.startRange.add(this.rangeDistance, this.rangeUnit),
      endRange:   this.state.endRange.add(this.rangeDistance, this.rangeUnit)
    });
  },
  handlePreviousRange: function () {
    var today = moment();
    var proposedStartRange = this.state.startRange.subtract(this.rangeDistance, this.rangeUnit);
    var proposedEndRange   = this.state.endRange.subtract(this.rangeDistance, this.rangeUnit);

    var isValidRange = !proposedStartRange.isBefore(today, 'day');
    if (isValidRange) {
      this.setState({
        startRange: proposedStartRange,
        endRange:   proposedEndRange
      });
    } else {
      this.setState({
        startRange: moment(),
        endRange:   moment().add(this.rangeDistance - 1, this.rangeUnit)
      })
    };
  },
  flatten: function (target) {
    var flattenedObject = [];
    for (key in target) {
      Array.prototype.push.apply(flattenedObject, target[key]);
    }
    return flattenedObject;
  },
  getDisabledSlots: function (selectedSlots) {
    selectedTimeRanges = selectedSlots.map(function(slot) {
        futureNearbySlots = moment.range(
          moment(slot.start_time).add({ minutes: 1 }),
          moment(slot.start_time).add({ minutes: 59 })
        );
        pastNearbySlots = moment.range(
            moment(slot.start_time).subtract({ minutes: 59 }),
            moment(slot.start_time).subtract({ minutes: 1 })
        );
        return [futureNearbySlots, pastNearbySlots];
    })

    if (selectedTimeRanges.length > 0) {
      selectedTimeRanges = selectedTimeRanges.reduce((finalRange, partialRange) => finalRange.concat(partialRange));
    };

    var disabledSlots = [];
    var allSlots = this.flatten(this.state.allSlots);

    selectedTimeRanges.forEach(function(slotRange){
      allSlots.forEach(function(slot) {
        var condition = moment(slot.start_time).within(slotRange);

        if (condition) {
          disabledSlots.push(slot);
        }
      }.bind(this))
    }.bind(this));

    // make sure disabled slots are unique
    // [ ] TODO (AJ) Make sure this acutally makes things unique
    disabledSlots = disabledSlots.filter(
      (item, pos) => disabledSlots.indexOf(item) == pos
    );

    return disabledSlots;
  },
  handleSlotClick: function (slot, active) {
    var newSelectedSlots = this.props.selectedSlots;

    // toggle slot from selected/unselected states
    if (active) {
      // user un-selects a slot

      // selectedSlots are now all slots that don't have the same id and start time
      newSelectedSlots = newSelectedSlots.filter(
        (targetSlot) => (slot.start_time != targetSlot.start_time && slot.id != targetSlot.id)
      );
      this.props.handleSlots(newSelectedSlots);

      var disabledSlots = this.getDisabledSlots(newSelectedSlots);
      this.props.handleDisabledSlots(disabledSlots);

      this.setDelegates(newSelectedSlots.length);
    } else {
      // user selects a slot
      newSelectedSlots.push(slot);
      this.props.handleSlots(newSelectedSlots);

      var disabledSlots = this.getDisabledSlots(newSelectedSlots);
      this.props.handleDisabledSlots(disabledSlots);

      this.setDelegates(newSelectedSlots.length);
    }
  },
  renderSlotDays: function () {
    var result = [];
    moment.range([this.state.startRange, this.state.endRange]).by("day", function (day) {
      var slots = this.state.allSlots[day.format("MM-DD-YYYY")] || [];
      result.push(<Day day={day} slots={slots} selectedSlots={this.props.selectedSlots} disabledSlots={this.props.disabledSlots} handleSlotClick={this.handleSlotClick} />);
    }.bind(this));
    return result;
  },
  render: function () {
    return (
      <div className="main-view">
        <div className="slot-selector">
          <SlotRangeControls handleNextRange={this.handleNextRange}
                             handlePreviousRange={this.handlePreviousRange}
                             />
         <ul className="schedule weekly-schedule">
          {
            this.renderSlotDays()
          }
          </ul>
        </div>
      </div>
    );
  }
});