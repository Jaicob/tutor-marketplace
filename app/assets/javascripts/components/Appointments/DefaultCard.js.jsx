var DefaultCard = React.createClass({
  getInitialState: function() {
    return {
      checked: false
    };
  },

  handleUseDefault: function(event) {
    if (!this.state.checked) {
      this.props.onCardSelect(this.props.currentStudent.customer);
    } else {
      this.props.onCardSelect("");
    }

    this.setState({
      checked: !this.state.checked
    });
  },

  render: function() {
    props = this.props;
    if (props.currentStudent.card && props.currentStudent.customer) {
      return(
        <div className="default-card">
          <h3>Default Card</h3>
          <p>Your default card is: {this.props.currentStudent.card}</p>
          <p><input type="checkbox" checked={this.state.checked} onChange={this.handleUseDefault} /> Use this card</p>
        </div>
      )
    } else {
      return (
        <div className="default-card">
          <h3>Default Card</h3>
          <p>You have no default card set.</p>
        </div>
      )
    }
  }
});