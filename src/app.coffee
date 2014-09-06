`/** @jsx React.DOM */`

encodeText = (object) ->
    text: encodeURIComponent(object.text)

textMixin = {
    getInitialState: ->
        text: ''
}

TextField = React.createClass

    mixins: [textMixin],

    handleChange: (text) ->

        @setState({text}, ->

            @props.stream.push(@state))

    render: ->

        valueLink = {
            value: @state.text,
            requestChange: @handleChange
        }

        `<input type="text" valueLink={valueLink} />`

Output = React.createClass

    mixins: [textMixin],

    componentWillMount: ->

        @props.stream.onValue(@setState.bind(this))

    render: ->

        text = @state.text

        `<output>{text}</output>`

textStream = new Bacon.Bus

outputStream = textStream.map(encodeText)

React.renderComponent(
    `<form>
        <TextField stream={textStream} />
        <br />
        <Output stream={outputStream} />
    </form>`,
    document.body
)
