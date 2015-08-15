var SlotSelector = React.createClass({
  rangeDistance: 6, // visible dates is rangeDistance + 1
  rangeUnit: 'days',
  getInitialState: function () {
      return {
          allSlots: [],
          startRange: moment(),
          endRange:   moment().add(this.rangeDistance, this.rangeUnit)
      };
  },
  componentDidMount: function () {
    this.componentWillReceiveProps(this.props);
  },
  componentWillReceiveProps: function (nextProps) {
    this.fetchSlots(nextProps.tutor);
  },
  fetchSlots: function (tutor) {
    var data = [
                {
                  created_at: "2015-08-15T19:19:41.440Z",
                  duration: 3600,
                  id: 372,
                  reservation_max: null,
                  reservation_min: null,
                  start_time: "2015-08-17T01:30:00.000Z",
                  status: "Open",
                  tutor_id: 21,
                  updated_at: "2015-08-15T19:19:41.440Z"
                }
              ];


    this.setState({
      allSlots: this.groupSlotsByDate(data)
    });

    this.groupSlotsByDate(this.state.allSlots)

    // var endpoint = API.endpoints.slots({
    //   tutor_id: tutor,
    //   start_range: this.state.startRange.format("YYYY-MM-DD"),
    //   end_range: this.state.endRange.format("YYYY-MM-DD")
    // })

    // var request = $.getJSON(endpoint)
    // request.success = function (data) {
    //   this.setState({
    //     allSlots: data
    //   });
    // }.bind(this)
  },
  groupSlotsByDate: function (slots) {
    var newSlots = {}
    for (var slot = slots.length - 1; slot >= 0; slot--) {
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
    this.setState({
      startRange: this.state.startRange.subtract(this.rangeDistance, this.rangeUnit),
      endRange:   this.state.endRange.subtract(this.rangeDistance, this.rangeUnit)
    });
  },
  handleSlotClick: function (slot) {
    var newSelectedSlots = this.props.selectedSlots

    // toggle slot from selected/unselected states
    var exists = newSelectedSlots.filter(function (item) { return item.id === slot.id }).length > 0
    if (exists) {
      newSelectedSlots = newSelectedSlots.filter(function (item) { return item.id !== slot.id })
    } else {
      newSelectedSlots.push(slot);
    }

    this.props.handleSlots(newSelectedSlots);
  },
  renderSlotDays: function () {
    var result = []
    moment.range([this.state.startRange, this.state.endRange]).by("day", function (day) {
      var slots = this.state.allSlots[day.format("MM-DD-YYYY")] || []
      result.push(<Day day={day} slots={slots} handleSlotClick={this.handleSlotClick} />)
    }.bind(this))
    return result
  },
  render: function () {
    return (
      <div className="appointment-selector__slot-selector">
        <SlotRangeControls handleNextRange={this.handleNextRange}
                           handlePreviousRange={this.handlePreviousRange}
                           />
        {
          this.renderSlotDays()
        }
      </div>
    );
  }
});