var PaymentForm = React.createClass({

  getInitialState: function() {
    return {
      student: {
        card: {card: ""},
        user: {full_name: ""}
      }
    };
  },

  componentDidMount: function() {
    this.getStudent();
  },

  getStudent: function() {
    var endpoint = API.endpoints.students();

    var request = $.get(endpoint);
    if (this.isMounted()) {
      request.success(function(data){
        this.setState({ student: data });
      }.bind(this));
    }
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