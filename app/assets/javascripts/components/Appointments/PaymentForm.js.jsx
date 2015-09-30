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

    var request = $.getJSON(endpoint);
    request.success(function(data){
      this.setState({ student: data });
    }.bind(this));
  },

  render: function() {
    console.log(this.state.student);
    return (
      <div id="payment-form">
        <DefaultCard currentStudent={this.state.student} />
        <NewCard currentStudent={this.state.student} />
      </div>
    );
  }
});