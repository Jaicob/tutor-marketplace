var DefaultCard = React.createClass({

  render: function() {
    return (
      <div>
        <h3>Default Card</h3>
        <p>Your default card is: {this.props.currentStudent.card.card}</p>
      </div>
    );
  }
});