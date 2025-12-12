import Quickshell // for PanelWindow
import Quickshell.Io // for Process
import QtQuick // for Text

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 37

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        Text {
            id: clock
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            color: "#cdd6f4"

            Process {
                id: dateProc
                command: ["date", "+%a, %b %d @ %I:%M%P"]
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
