//Author:张哲
//Last modification time：2018-06-29
import QtQuick 2.0
import VPlay 2.0
import QtQuick.Controls 2.2

Item {

    //关于菜单
    BackgroundImage {
        anchors.fill: parent
        id: bgImage
        source: "qrc:/interface/mainInterface/setting.png"
        Rectangle {
            id: textfield
            color: "gray"
            width: parent.width * 0.8
            height: parent.height * 0.6
            anchors.topMargin: parent.width * 0.1
            anchors.bottomMargin: parent.width * 0.1
            anchors.leftMargin: parent.width * 0.1
            anchors.rightMargin: parent.width * 0.1
            anchors.centerIn: parent
            z: 1
            opacity: 0.5
        }
        TextArea {
            z: 2
            id: aboutInformation
            width: textfield.width * 0.8
            font.pixelSize: 0.03 * bgImage.height
            font.bold: true
            height: textfield.height * 0.6
            anchors.centerIn: textfield
            text: "\n支持局域网联网对战\n\n的简易中国象棋。\n\n源码来自重庆师范\n大学开源16组\n www.cqnu.edu.cn"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
        MyButton {
            id: returnButton
            source: "qrc:/interface/mainInterface/buttonSkin.png"
            text: "返回"
            width: bgImage.width * 0.4
            height: 0.1 * bgImage.height
            anchors.bottom: bgImage.bottom
            anchors.right: bgImage.right
            onChangedPage: {
                stackview.pop()
            }
        }
    }
}
