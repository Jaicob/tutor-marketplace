var PaymentForm = React.createClass({

  render: function () {
    if (Object.keys(this.props.currentStudent).length > 0) {
      return (
        <div>
          <DefaultCard currentStudent={this.props.currentStudent} />
          <NewCard currentStudent={this.props.currentStudent} />
        </div>
      );
    } else {
      return (
        <div>
          <h3>You are not signed in</h3>
          <div className="gi-1-2">
            <h4>Log in</h4>
          </div>
          <div className="gi-1-2">
            <h4>Sign Up</h4>
          </div>
        </div>
      );
    }
  }
});