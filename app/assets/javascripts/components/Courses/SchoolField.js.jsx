SchoolField = React.createClass({
  getInitialState: function () {
      return {
          all_schools: []
      };
  },
  componentDidMount: function (nextProps) {
      $.get(API_LOCATION + '/schools', function(data){
        this.setState({
          all_schools: data
        })
      }.bind(this));
  },
  render: function(){
    return (
      <div className="medium-3 columns">
        <select name="course[school_id]" defaultValue="Course" onChange={this.props.update}>
          <option disabled="true">School</option>
          {
            this.state.all_schools.map(function(school){
              return <option key={school.id} value={school.id}>{school.name}</option>
            })
          }
        </select>
      </div>
    )
  }
});