"Make sure to handle errors properly"
TranscriptStream redirectToStdOut: true.
thisContext insertSender: (Context contextOn: UnhandledError, ProvideAnswerNotification do: [:ex |
		Transcript showln: (String streamContents: [:stream | ex signalerContext errorReportOn: stream]).
		Smalltalk snapshot: true andQuitWithExitCode: 1]).


self
	assert: (Smalltalk globals hasBindingOf: #CIPrepareImageTestPrepared) not
		description: 'prepare: image has already been prepared';
	assert: (Smalltalk globals hasBindingOf: #CIPrepareImageTestPostpared) not
		description: 'prepare: image has already been postpared';
	assert: (Smalltalk globals hasBindingOf: #CIPrepareImageTestTesting) not
		description: 'prepare: image has already been tested'.

Smalltalk globals at: #CIPrepareImageTestPrepared put: DateAndTime now.
