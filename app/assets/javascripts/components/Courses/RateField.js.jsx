RateField = React.createClass({
  render: function(){
    field = <input type="number"
                   disabled={this.props.course == ""}
                   name="tutor_course[rate]"
                   placeholder="Rate"
                   onChange={this.props.update} />
    return (
      <div className="medium-3 columns">
        <div className="row collapse">
          <div className="small-2 large-2 columns">
            <span className="prefix">$</span>
          </div>
          <div className="small-7 medium-4 large-5 columns">
            {field}
          </div>
          <div className="small-3 medium-6 large-5 columns">
            <span className="postfix" style={{"borderLeft":"0"}}>per hour</span>
          </div>
        </div>
      </div>
    )
  }
})