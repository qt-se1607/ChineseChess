//Author:王梦娟
//Last modification time：2018-06-28
import QtQuick 2.0

Item {
    //游戏中的计时器
    property int timecount: 0

    signal countChanged(int count)

    Timer {
        id: time
        interval: 1000
        //        running: true
        triggeredOnStart: true
        repeat: true

        onTriggered: {

            timecount += 1
            tu1.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time" + Math.floor(
                        timecount / 600) + ".png"
            tu2.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time" + Math.floor(
                        timecount % 600 / 60) + ".png"
            tu4.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time" + Math.floor(
                        timecount % 60 / 10) + ".png"
            tu5.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time" + Math.floor(
                        timecount % 10) + ".png"
        }
    }

    Image {
        id: tu1
        anchors.left: parent.left
        width: 1 / 16 * parent.width
        height: 0.85 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
    }
    Image {
        id: tu2
        anchors.left: tu1.right
        width: 1 / 16 * parent.width
        height: 0.85 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
    }
    Image {
        id: tu3
        anchors.left: tu2.right
        width: 1 / 16 * parent.width
        height: 0.85 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/time/time10.png"
    }
    Image {
        id: tu4
        anchors.left: tu3.right
        width: 1 / 16 * parent.width
        height: 0.85 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
    }
    Image {
        id: tu5
        anchors.left: tu4.right
        width: 1 / 16 * parent.width
        height: 0.85 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
    }
    function startTimer() {
        time.start()
    }
    function stopTimer() {
        time.stop()
        tu1.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
        tu2.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
        tu4.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
        tu5.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
    }

    //步数记录
    Image {
        id: ge
        anchors.right: parent.right
        anchors.rightMargin: 0.5 * width
        width: 1 / 16 * parent.width
        height: 0.85 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
    }
    Image {
        id: shi
        anchors.right: ge.left
        width: 1 / 16 * parent.width
        height: 0.85 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
    }
    Image {
        id: bai
        anchors.right: shi.left
        width: 1 / 16 * parent.width
        height: 0.85 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/time/time0.png"
    }
    onCountChanged: {
        ge.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time" + Math.floor(
                    count % 10) + ".png"
        shi.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time" + Math.floor(
                    count / 10 % 10) + ".png"
        bai.source = "qrc:/skins/skin" + setting.skinImageNumber + "/time/time" + Math.floor(
                    count / 100) + ".png"
    }
}
