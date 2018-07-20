//Author:张哲
//Last modification time：2018-07-01
import QtQuick 2.0
import VPlay 2.0
import bluetooth 1.0

Item {
    //联机对战的选项列表
    id: top
    BackgroundImage {
        anchors.fill: parent
        id: backImage
        source: "qrc:/interface/mainInterface/setting.png"
        Image {
            id: lianjiduiyiImage
            source: "qrc:/interface/fontImages/lianjiduiyi1.png"
            scale: 0.7
            anchors.horizontalCenter: parent.horizontalCenter
            y: 0.1 * backImage.height
        }

        Image {
            id: mainMenu
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: 0.6 * parent.height
            width: 0.6 * parent.width
            source: "qrc:/interface/mainInterface/mainInterface.png"
            MyButton {
                id: returnButton
                source: "qrc:/interface/mainInterface/buttonSkin.png"
                Image {
                    id: fanhuiImage
                    anchors.centerIn: parent
                    scale: 0.6
                    source: "qrc:/interface/fontImages/fanhui.png"
                }
                width: parent.width
                height: 0.2 * parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: mainMenu.bottom
                anchors.bottomMargin: 0.3 * height
                onChangedPage: {
                    stackview.pop()
                }
            }
            MyButton {
                id: creatGame
                width: parent.width
                height: 0.2 * parent.height
                source: "qrc:/interface/mainInterface/buttonSkin.png"
                Image {
                    id: lanYaImage
                    anchors.centerIn: parent
                    scale: 0.6
                    source: "qrc:/interface/fontImages/lanya.png"
                }
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: mainMenu.top
                anchors.topMargin: 0.3 * height
                onChangedPage: {
                    blueConnect.mainMenu.visible = true
                    stackview.push(blueConnect)
                }
            }

            MyButton {
                id: joinGame
                width: parent.width
                height: 0.2 * parent.height

                source: "qrc:/interface/mainInterface/buttonSkin.png"
                Image {
                    id: juyuwangImage
                    anchors.centerIn: parent
                    scale: 0.6
                    source: "qrc:/interface/fontImages/juyuwang.png"
                }
                anchors.centerIn: mainMenu
                onChangedPage: {
                    netSocket.mainMenu.visible = true
                    stackview.push(netSocket)
                }
            }
        }
    }
}
