//Author:赵亚伟 张哲
//Last modification time：2018-07-01
import QtQuick 2.0
import VPlay 2.0
import bluetooth 1.0

Item {
    //蓝牙连接接口
    property alias mainMenu: mainMenu
    id: top
    Image {
        anchors.fill: parent
        id: backImage
        source: "qrc:/interface/mainInterface/setting.png"
        Image {
            id: titleImage
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/interface/fontImages/lanya.png"
            scale: 0.7
            y: 0.1 * backImage.height
        }

        Image {
            id: mainMenu
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: 0.6 * parent.height
            width: 0.6 * parent.width
            source: "qrc:/interface/mainInterface/mainInterface.png"
            Text {
                anchors.bottom: creatGame.top
                anchors.left: creatGame.left
                anchors.leftMargin: creatGame.width * 0.5
                id: tiXingLanYaKaiQi
                text: bluetooth.isOpenOrNot() ? "蓝牙已打开" : "蓝牙未打开"
            }

            MyButton {
                id: creatGame
                width: parent.width
                height: 0.2 * parent.height
                source: "qrc:/interface/mainInterface/buttonSkin.png"
                Image {
                    id: createGameImage
                    anchors.centerIn: parent
                    scale: 0.6
                    source: "qrc:/interface/fontImages/chuangjianduiju.png"
                }
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: mainMenu.top
                anchors.topMargin: 0.3 * height
                onChangedPage: {
                    mainMenu.visible = false
                    returnButton2.visible = true
                    bluetooth.openServer()
                }
            }
            //            Image {
            //                id: bluetoothImage
            //                visible: false
            //                source: "qrc:/interface/mainInterface/default.png"
            //                anchors.top: parent.top
            //                anchors.topMargin: 10
            //                anchors.horizontalCenter: parent.horizontalCenter

            //                RotationAnimation on rotation {
            //                    id: ranimation
            //                    target: bluetoothImage
            //                    easing.type: Easing.InOutBack
            //                    property: "rotation"
            //                    from: 0
            //                    to: 360
            //                    duration: 2000
            //                    loops: Animation.Infinite
            //                    alwaysRunToEnd: true
            //                    running: true
            //                }
            //            }

            //            Text {
            //                id: searchText
            //                visible: false
            //                anchors.top: bluetoothImage.bottom
            //                //anchors.bottom: parent.bottom
            //                anchors.topMargin: 10
            //                anchors.horizontalCenter: parent.horizontalCenter
            //                font.pointSize: bluetoothImage.height * 0.2
            //                text: qsTr("搜索服务器中")
            //                color: "black"
            //            }
            MyButton {
                id: joinGame
                width: parent.width
                height: 0.2 * parent.height

                source: "qrc:/interface/mainInterface/buttonSkin.png"
                Image {
                    id: xuanzeImage
                    anchors.centerIn: parent
                    scale: 0.6
                    source: "qrc:/interface/fontImages/jiaruduiju.png"
                }
                anchors.centerIn: mainMenu
                onChangedPage: {
                    mainMenu.visible = false
                    joinMenu.visible = true
                    returnButton2.visible = true
                    bluetooth.scan()
                }
            }
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
                    mainMenu.visible = false
                }
            }
        }
        BlueTooth {
            //蓝牙每搜到一个设备，添加设备到列表
            id: bluetooth
            onFindDifferentDevice: {
                listModel.append({
                                     value1: name,
                                     value2: address
                                 })
            }
        }

        Image {
            id: joinMenu
            visible: false
            source: "qrc:/interface/mainInterface/mainInterface.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            MyButton {
                //蓝牙扫描界面的返回键
                id: returnButton2
                source: "qrc:/interface/mainInterface/buttonSkin.png"
                Image {
                    id: returnImage
                    anchors.centerIn: parent
                    scale: 0.6
                    source: "qrc:/interface/fontImages/fanhui.png"
                }
                width: backImage.width * 0.4
                height: 0.1 * backImage.height
                x: 0.45 * backImage.width
                y: 0.55 * backImage.height
                onChangedPage: {
                    mainMenu.visible = true
                    joinMenu.visible = false
                    returnButton2.visible = false
                    stackview.pop()
                }
            }

            MyButton {
                //蓝牙扫描界面的搜索键
                id: returnButton3
                source: "qrc:/interface/mainInterface/buttonSkin.png"
                Image {
                    id: serachImage
                    anchors.centerIn: parent
                    scale: 0.6
                    source: "qrc:/interface/fontImages/sousuo.png"
                }
                width: backImage.width * 0.4
                height: 0.1 * backImage.height
                x: backImage.width * 0.001
                y: 0.55 * backImage.height
                onChangedPage: {
                    bluetooth.scan()
                }
            }
            ListView {
                id: listView
                anchors.fill: parent
                anchors.topMargin: mainMenu.height * 0.09
                anchors.leftMargin: mainMenu.width * 0.1
                anchors.bottomMargin: mainMenu.height * 0.1
                model: ListModel {
                    id: listModel
                }

                clip: true
                delegate: Rectangle {
                    id: recText
                    width: joinMenu.width * 0.8
                    height: joinMenu.height * 0.1
                    opacity: 0.7
                    color: ListView.isCurrentItem ? "red" : "gray" //选中颜色设置
                    border.color: Qt.lighter(color, 1.1)
                    radius: 10
                    Text {
                        id: information
                        text: value1 + "," + value2
                        font.pixelSize: joinMenu.height * 0.05
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            listView.currentIndex = index //实现item切换
                            console.log(listModel.get(index).value1)
                            bluetooth.establshConnect(
                                        listModel.get(index).value2) //单击建立连接
                            console.log(listModel.get(index).value2)
                        }
                    }
                }
                spacing: 5
                focus: true
            }
        }
    }
}
