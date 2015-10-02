var PaymentForm = React.createClass({

  getInitialState: function() {
    return {
      student: {}
    };
  },

  componentDidMount: function() {
    this.getStudent();
  },

  getStudent: function() {
    var endpoint = API.endpoints.students();
    var request = $.get(endpoint);
    var callback = function(data){
      this.setState({ student: data });
    }.bind(this)
    request.success(callback);
  },

  render: function() {
    return (
      <div id="payment-form">
        <DefaultCard currentStudent={this.state.student} />
        <NewCard currentStudent={this.state.student} />
      </div>
    );
  }
});