var SlotRangeControls = React.createClass({
  displayName: "SlotRangeControls",

  render: function () {
    return React.createElement(
      "nav",
      { className: "calendar-nav" },
      React.createElement(
        "ul",
        { className: "navigation-menu navigation--schedule" },
        React.createElement(
          "li",
          { className: "menu-item" },
          React.createElement(
            "a",
            { onClick: this.props.handlePreviousRange, className: "btn date-range-paginate previous", alt: "This Week", title: "This Week", rel: "nofollow" },
            React.createElement("span", { className: "fi-arrow-left" }),
            " Previous Week"
          )
        ),
        React.createElement(
          "li",
          { className: "menu-item" },
          React.createElement(
            "a",
            { onClick: this.props.handleNextRange, className: "btn date-range-paginate next", alt: "Next Week", title: "Next Week", rel: "nofollow" },
            "Next Week ",
            React.createElement("span", { className: "fi-arrow-right" })
          )
        )
      )
    );
  }
});