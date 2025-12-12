import Quickshell // for PanelWindow
import Quickshell.Io // for Process
import QtQuick // for Text

PanelWindow {
    anchors {
        top: false
        left: true
        right: true
        bottom: true
    }

    implicitHeight: 37

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#1e1e2e"
        Text {
            id: clock
            // center the bar in its parent component (the window)
            anchors.centerIn: parent
            anchors.right: parent
            color: "#cdd6f4"

            Process {
                id: dateProc
                command: ["date"]
                running: true
                stdout: StdioCollector {
                    onStreamFinished: clock.text = this.text
                }
            }
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: dateProc.running = true
            }
        }
    }
}
