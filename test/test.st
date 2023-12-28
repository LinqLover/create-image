| arguments expectedVersion systemVersion actualVersion |
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

arguments := Smalltalk arguments.
arguments first = '--' ifTrue: [arguments := arguments allButFirst]. "<= Squeak 5.3"
expectedVersion := arguments first.
systemVersion := SystemVersion current.
actualVersion :=systemVersion isAlpha
	ifTrue: ['trunk']
	ifFalse: ['{1}.{2}' format: {systemVersion majorVersionNumber. systemVersion minorVersionNumber}].
self
	assert: actualVersion = expectedVersion
	description: ('test: image version is {1} but expected {2}' format: {actualVersion. expectedVersion}).

expectedBitness := arguments second asNumber.
actualBitness := Smalltalk image wordSize * 8.
self
	assert: actualBitness = expectedBitness
	description: ('test: image bitness is {1} but expected {2}' format: {actualBitness. expectedBitness}).

Transcript showln: 'All tests passed!!'.
Smalltalk snapshot: false andQuit: true.
