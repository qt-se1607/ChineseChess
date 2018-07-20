//Author:张哲
//Last modification time：2018-07-01
import QtQuick 2.4
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

Item {
    property alias source: image.source
    property alias text: infor.text
    property string str
    signal changedPage(string str)
    Rectangle {
        id: round
        width: 0.9 * parent.width
        height: 0.9 * parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        radius: width / 3
        visible: false
    }
    Image {
        id: image
        visible: false
    }

    OpacityMask {
        id: mask
        visible: true
        anchors.fill: round
        source: image
        maskSource: round
        MultiPointTouchArea {
            id: mouseArea
            anchors.fill: parent
            touchPoints: [
                TouchPoint {
                }
            ]
        }
    }
    Text {
        anchors.fill: round
        id: infor
        color: "#ffffff"
        font.pixelSize: 0.25 * height
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
    Connections {
        target: mouseArea
        onPressed: {
            mask.scale = 0.95 //当按下缩放到0.95
        }
        onReleased: {
            mask.scale = 1 //取开缩放回1
            if (audioManager.bgId.playing == true) {
                buttonSound.play()
            } else if (audioManager.bgId.playing == false) {
                buttonSound.stop()
            }
            changedPage(str)
        }
    }
    Audio {
        id: buttonSound
        loops: 0
        source: "qrc:/interface/sound/button.wav"
    }
}
