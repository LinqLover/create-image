| prepareScriptPath postpareScriptPath postpareScript |
[
	"Debugging convenience & fail-safety"
	FileStream startUp: true. "Reload stdio file handles"
	TranscriptStream redirectToStdOut: true.
	thisContext insertSender: (Context contextEnsure: [TranscriptStream redirectToStdOut: false]).
	
	thisContext insertSender: (Context contextOn: UnhandledError, ProvideAnswerNotification do: [:ex |
		Transcript showln: (String streamContents: [:stream | ex signalerContext errorReportOn: stream]).
		Smalltalk snapshot: true andQuitWithExitCode: 1]).
	thisContext
		insertSender: (Context contextOn: ProgressInitiationException do: [:ex |
			ex sendNotificationsTo: [:min :max :curr |
				Transcript showln: ('[Progress] [{1}/{2}:{3}] {4}' format: {curr. min. max. ex messageText})]]);
		insertSender: (Context contextOn: ProgressNotification do: [:ex |
			Transcript showln: ('[Progress] {1}' format: {({ex messageText. ex extraParam}) joinSeparatedBy: $|}).
			ex resume]).
	
	"Install the latest updates that are not yet included in the downloaded build."
	MCMcmUpdater default doUpdate: false.
	
	prepareScriptPath := Smalltalk argumentAt: 1.
	postpareScriptPath := Smalltalk argumentAt: 2.
	
	postpareScript := postpareScriptPath isEmptyOrNil ifFalse: [
		FileStream readOnlyFileNamed: postpareScriptPath do: [:stream | stream contents]].
	
	prepareScriptPath isEmptyOrNil ifFalse: [
		Smalltalk globals at: #CIPrepareImageDirectory put: (FileDirectory forFileName: prepareScriptPath).
		FileStream readOnlyFileNamed: prepareScriptPath do: [:stream | stream fileIn].
		Smalltalk globals removeKey: #CIPrepareImageDirectory].
] value.

Smalltalk snapshot: true andQuitWithExitCode: 0.

postpareScript ifNotNil: [
	postpareScript readStream fileIn].
