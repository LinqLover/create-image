"Make sure to handle errors properly"
TranscriptStream redirectToStdOut: true.
thisContext insertSender: (Context contextOn: UnhandledError, ProvideAnswerNotification do: [:ex |
		Transcript showln: (String streamContents: [:stream | ex signalerContext errorReportOn: stream]).
		Smalltalk snapshot: true andQuitWithExitCode: 1]).


self
	assert: (Smalltalk globals hasBindingOf: #CIPrepareImageTestPrepared)
		description: 'test: image has not been prepared';
	assert: (Smalltalk globals at: #CIPrepareImageTestPrepared) < DateAndTime now
		description: 'test: image has been prepared later'.

self
	assert: (Smalltalk globals hasBindingOf: #CIPrepareImageTestPostpared)
		description: 'test: image has not been postpared';
	assert: (Smalltalk globals at: #CIPrepareImageTestPostpared) > (Smalltalk globals at: #CIPrepareImageTestPrepared)
		description: 'test: image has been postpared before prepared';
	assert: (Smalltalk globals at: #CIPrepareImageTestPostpared) < DateAndTime now
		description: 'test: image has been postpared later'.

self
	assert: (Smalltalk globals hasBindingOf: #CIPrepareImageTestTesting) not
	description: 'test: image has already been tested'.
Smalltalk globals at: #CIPrepareImageTestPostpared put: DateAndTime now.

Transcript showln: 'All tests passed!!'.
Smalltalk snapshot: false andQuit: true.
