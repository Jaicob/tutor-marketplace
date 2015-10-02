var DefaultCard = React.createClass({

  getInitialState: function() {
    console.log(this.props.currentStudent);
    return {
      student: this.props.currentStudent
    };
  },

  render: function() {
    console.log(this.props.currentStudent);
    return (
      <div>
        <h3>Default Card</h3>
        <p>Your default card is: { this.state.student.length > 0 ? this.state.student.card.card : "" }</p>
      </div>
    );
  }
});