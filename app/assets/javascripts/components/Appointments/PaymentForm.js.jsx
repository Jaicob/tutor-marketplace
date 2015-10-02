var PaymentForm = React.createClass({

  render: function () {
    return (
      <div>
        <DefaultCard currentStudent={this.props.currentStudent} />
        <NewCard currentStudent={this.props.currentStudent} />
      </div>
    );
  }
});