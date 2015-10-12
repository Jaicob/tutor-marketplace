var DefaultCard = React.createClass({
  getInitialState: function() {
    return {
      checked: false
    };
  },

  handleUseDefault: function(event) {
    this.setState({checked: !this.state.checked});
    this.props.onCardSelect(this.props.currentStudent.customer_id);
  },

  render: function() {
    return (
      <div>
        <h3>Default Card</h3>
        <p>Your default card is: {this.props.currentStudent.card}</p>
        <p><input type="checkbox" checked={this.state.checked} onChange={this.handleUseDefault} /> Use this card</p>
      </div>
    );
  }
});