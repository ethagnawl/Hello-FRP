/** @jsx React.DOM */;
var Output, TextField, encodeText, outputStream, textMixin, textStream;

encodeText = function(object) {
  return {
    text: encodeURIComponent(object.text)
  };
};

textMixin = {
  getInitialState: function() {
    return {
      text: ''
    };
  }
};

TextField = React.createClass({
  mixins: [textMixin],
  handleChange: function(text) {
    return this.setState({
      text: text
    }, function() {
      return this.props.stream.push(this.state);
    });
  },
  render: function() {
    var valueLink;
    valueLink = {
      value: this.state.text,
      requestChange: this.handleChange
    };
    return <input type="text" valueLink={valueLink} />;
  }
});

Output = React.createClass({
  mixins: [textMixin],
  componentWillMount: function() {
    return this.props.stream.onValue(this.setState.bind(this));
  },
  render: function() {
    var text;
    text = this.state.text;
    return <output>{text}</output>;
  }
});

textStream = new Bacon.Bus;

outputStream = textStream.map(encodeText);

React.renderComponent(<form>
        <TextField stream={textStream} />
        <br />
        <Output stream={outputStream} />
    </form>, document.body);
