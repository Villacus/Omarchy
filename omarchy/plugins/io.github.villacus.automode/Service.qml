import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  property var shell: null
  property var manifest: null

  readonly property string scriptPath: (manifest && manifest.__sourceDir ? manifest.__sourceDir : "") + "/detect.sh"
  readonly property string helperPath: (manifest && manifest.__sourceDir ? manifest.__sourceDir : "") + "/automode.sh"
  readonly property int pollIntervalMs: 5000
  readonly property int endGraceMs: 15000

  property bool sessionActive: false

  function runProcess(process, command) {
    if (process.running) return false
    process.command = command
    process.running = true
    return true
  }

  function handleDetection(raw) {
    try {
      var data = JSON.parse(String(raw || ""))
      var game = data && data.game === true

      if (game) {
        endGraceTimer.stop()
        if (!root.sessionActive) startSession()
      } else if (root.sessionActive && !endGraceTimer.running) {
        endGraceTimer.restart()
      }
    } catch (e) {}
  }

  function startSession() {
    root.sessionActive = true
    runProcess(modeProcess, ["bash", root.helperPath, "enter"])
  }

  function endSession() {
    root.sessionActive = false
    runProcess(modeProcess, ["bash", root.helperPath, "exit"])
  }

  Timer {
    id: pollTimer
    interval: root.pollIntervalMs
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!detectionProcess.running) detectionProcess.running = true
  }

  Timer {
    id: endGraceTimer
    interval: root.endGraceMs
    repeat: false
    onTriggered: if (root.sessionActive) root.endSession()
  }

  Process {
    id: detectionProcess
    command: ["bash", root.scriptPath]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.handleDetection(text)
    }
  }

  Process { id: modeProcess }

  IpcHandler {
    target: "io.github.villacus.automode"
    function status(): string {
      return JSON.stringify({ sessionActive: root.sessionActive })
    }
  }
}
