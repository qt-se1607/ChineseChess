//Author:王梦娟
//Last modification time：2018-07-03
import QtQuick 2.0
import VPlay 2.0
import QtQuick.Controls 2.1

Item {
    //主界面的动画加载
    property int zicount: 0
    property int huacount: 0
    signal begin
    z: 1
    BackgroundImage {
        id: bgImage
        source: "qrc:/interface/donghua/bei1.png"
        anchors.fill: parent
    }

    Image {
        id: yun
        x: 0 - parent.width
        source: "qrc:/interface/donghua/yun.png"
        height: 0.5 * parent.height
        width: parent.width
    }

    NumberAnimation {
        id: yundong
        target: yun
        property: "x"
        from: 0 - yun.width
        to: yun.width
        duration: 10000
        loops: Animation.Infinite
    }

    Image {
        id: zhong
        width: 0.233 * parent.width
        height: 0.135 * parent.height
        anchors.top: parent.top
        x: width / 4
    }
    Image {
        id: guo
        width: 0.179 * parent.width
        height: 0.114 * parent.height
        anchors.top: zhong.bottom
        x: zhong.width / 2 + zhong.x
    }
    Image {
        id: xiang
        width: 0.25 * parent.width
        height: 0.197 * parent.height
        anchors.top: guo.bottom
        x: zhong.x
    }
    Image {
        id: qi
        width: 0.252 * parent.width
        height: 0.142 * parent.height
        anchors.top: xiang.bottom
        x: zhong.x
    }

    Image {
        id: hua
        height: 0.231 * parent.height
        width: parent.width
        anchors.bottom: parent.bottom
        z: 1
    }

    Image {
        id: hehua
        x: 0.5 * parent.width
        anchors.bottom: parent.bottom
        width: 0.494 * parent.width
        height: 0.323 * parent.height
        z: 0
    }

    Timer {
        id: zi
        repeat: true
        interval: 100
        onTriggered: {
            loadzi()
        }
    }

    Timer {
        id: huatime
        repeat: true
        interval: 80
        onTriggered: {
            loadhua()
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            start()
        }
    }
    MyButton {
        visible: false
        id: blackPoint0
        x: parent.width * (1 / 2) + parent.width * (1 / 16)
        y: parent.height * (1 / 15)
        width: 0.3 * parent.width
        height: 0.2 * parent.height
        source: "qrc:/interface/mainInterface/blackPoint0.png"
        Image {
            id: danjiImage
            anchors.centerIn: parent
            scale: 0.7
            source: "qrc:/interface/fontImages/danji.png"
        }
        onChangedPage: {
            //            gameArea.createField()
            stackview.push(gameArea)
            gameArea.start()
        }
    }
    MyButton {
        visible: false
        id: blackPoint1
        anchors.top: blackPoint0.bottom
        x: parent.width * (5 / 7)
        width: 0.3 * parent.width
        height: 0.2 * parent.height
        source: "qrc:/interface/mainInterface/blackPoint1.png"
        Image {
            id: lianjieImage
            anchors.centerIn: parent
            scale: 0.7
            source: "qrc:/interface/fontImages/lianji.png"
        }
        onChangedPage: {
            stackview.push(fightOption)
        }
    }

    MyButton {
        visible: false
        id: blackPoint2
        x: parent.width * (1 / 2) + parent.width * (1 / 16)
        y: parent.height * (1 / 15) + blackPoint1.height + blackPoint0.height
        width: 0.3 * parent.width
        height: 0.2 * parent.height
        source: "qrc:/interface/mainInterface/blackPoint.png"
        Image {
            id: aboutImage
            anchors.centerIn: parent
            scale: 0.8
            source: "qrc:/interface/fontImages/guanyu.png"
        }

        onChangedPage: {
            stackview.push(about)
        }
    }
    MyButton {
        visible: false
        id: blackPoint3
        x: parent.width * (2 / 8)
        y: parent.height * (6 / 10)
        width: 0.3 * parent.width
        height: 0.2 * parent.height
        source: "qrc:/interface/mainInterface/blackPoint2.png"
        Image {
            id: settingImage
            anchors.centerIn: parent
            scale: 0.8
            source: "qrc:/interface/fontImages/shezhi.png"
        }
        str: "setting"
        onChangedPage: {
            stackview.push(setting)
        }
    }
    function loadzi() {
        zicount++
        if (zicount > 13) {
            zi.stop()
            xiang.source = "qrc:/interface/donghua/xiang.png"
            huatime.start()
        } else if (zicount > 0 && zicount < 4) {
            zhong.source = "qrc:/interface/donghua/zi" + zicount + ".png"
        } else if (zicount > 3 && zicount < 7) {
            guo.source = "qrc:/interface/donghua/zi" + zicount + ".png"
        } else if (zicount > 6 && zicount < 11) {
            xiang.source = "qrc:/interface/donghua/zi" + zicount + ".png"
        } else if (zicount > 10 && zicount < 14) {
            qi.source = "qrc:/interface/donghua/zi" + zicount + ".png"
        }
    }

    function loadhua() {
        huacount++
        if (huacount > 7) {
            huatime.stop()
            blackPoint0.visible = true
            blackPoint1.visible = true
            blackPoint2.visible = true
            blackPoint3.visible = true
            yundong.start()
        } else {
            hua.source = "qrc:/interface/donghua/hua" + huacount + ".png"
            if (huacount == 6)
                hehua.source = "qrc:/interface/donghua/hehua1.png"
            if (huacount == 7)
                hehua.source = "qrc:/interface/donghua/hehua2.png"
        }
    }
    function start() {
        zi.start()
    }
}
