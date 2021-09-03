"Make sure to handle errors properly"
TranscriptStream redirectToStdOut: true.
thisContext insertSender: (Context contextOn: UnhandledError, ProvideAnswerNotification do: [:ex |
		Transcript showln: (String streamContents: [:stream | ex signalerContext errorReportOn: stream]).
		Smalltalk snapshot: true andQuitWithExitCode: 1]).


self
	assert: (Smalltalk globals hasBindingOf: #CIPrepareImageTestPrepared)
		description: 'postpare: image has not yet been prepared';
	assert: (Smalltalk globals hasBindingOf: #CIPrepareImageTestPostpared) not
		description: 'postpare: image has already been postpared';
	assert: (Smalltalk globals hasBindingOf: #CIPrepareImageTestTesting) not
		description: 'postpare: image has already been tested'.

Smalltalk globals at: #CIPrepareImageTestPostpared put: DateAndTime now.
