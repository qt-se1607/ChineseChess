//Author:赵亚伟 张哲
//Last modification time：2018-07-05
import QtQuick 2.0
import VPlay 2.0
import QtQuick.Controls 2.0
import Qt.labs.platform 1.0
import network 1.0

Item {
    //局域网的连接
    property string ipAddress
    property alias mainMenu: netSocketList
    id: topItem
    BackgroundImage {
        anchors.fill: parent
        id: backImage
        source: "qrc:/interface/mainInterface/setting.png"
        Image {
            //标题图
            id: titleImage
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/interface/fontImages/juyuwang.png"
            scale: 0.7
            y: 0.1 * backImage.height
        }

        Image {
            //菜单图
            id: mainMenu
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: 0.6 * parent.height
            width: 0.6 * parent.width
            Image {
                anchors.fill: parent
                source: "qrc:/interface/mainInterface/mainInterface.png"
                id: netSocketList
                visible: false
                MyButton {
                    //菜单下所管理的按钮
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
                    anchors.top: parent.top
                    anchors.topMargin: 0.3 * height
                    onChangedPage: {
                        creatColumn.visible = true
                        netSocketList.visible = false
                        network.openServer()
                        addressShow.text = qsTr(
                                    "本机IP地址为:") + "\n\n" + network.accessLocalIP(
                                    ) + "\n" + "\n确保连接后再" + "\n开始游戏"
                    }
                }
                MyButton {
                    //加入游戏按钮
                    id: joinGame
                    width: parent.width
                    height: 0.2 * parent.height

                    source: "qrc:/interface/mainInterface/buttonSkin.png"
                    Image {
                        id: joinGameImage
                        anchors.centerIn: parent
                        scale: 0.6
                        source: "qrc:/interface/fontImages/jiaruduiju.png"
                    }
                    anchors.centerIn: parent
                    onChangedPage: {
                        netSocketList.visible = false
                        joinColumn.visible = true
                    }
                }
            }

            //创建服务器界面
            Image {
                //创建服务器的提示信息
                id: creatColumn
                anchors.fill: parent
                source: "qrc:/interface/mainInterface/mainInterface.png"
                visible: false
                Text {
                    id: addressShow
                    width: parent.width * 0.8
                    x: 0.27 * mainMenu.width
                    y: 0.1 * mainMenu.height
                    font.pixelSize: parent.height * 0.04
                    text: qsTr("本机IP地址为:") + "\n\n" + network.accessLocalIP(
                              ) + "\n" + "\n确保连接后再" + "\n开始游戏"
                }

                Text {
                    id: text
                    text: "等待连接中..."
                    font.bold: true
                    font.pixelSize: parent.height * 0.05
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                } //动画实现字体的显示和隐藏
                SequentialAnimation {
                    id: busyThrobber
                    running: true
                    NumberAnimation {
                        target: text
                        property: "opacity"
                        from: 0.8
                        to: 0
                        duration: 1500
                    }
                    NumberAnimation {
                        target: text
                        property: "opacity"
                        to: 0.8
                        from: 0
                        duration: 1500
                    }
                    loops: Animation.Infinite
                }
            }
            //-----加入游戏
            Image {
                id: joinColumn
                anchors.fill: parent
                source: "qrc:/interface/mainInterface/mainInterface.png"
                visible: false
                TextField {
                    placeholderText: qsTr("请输入服务器IP地址")
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: mainMenu.height * 0.2
                    width: mainMenu.width * 0.8
                    height: mainMenu.height * 0.1
                    font.pixelSize: height * 0.5
                    id: ipLineEdit
                    validator: RegExpValidator {
                        //正则表达式限制输入
                        regExp: /[0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}/
                    }
                }

                MyButton {
                    //点击连接按钮
                    id: connectIpAddress
                    source: "qrc:/interface/mainInterface/buttonSkin.png"
                    Image {
                        id: lianjieImage
                        anchors.centerIn: parent
                        scale: 0.6
                        source: "qrc:/interface/fontImages/lianjie.png"
                    }
                    width: parent.width
                    height: 0.2 * parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: mainMenu.height * 0.4
                    onChangedPage: {
                        if (!ipLineEdit.acceptableInput) {
                            invalidIPDialog.visible = true
                        } else {
                            ipAddress = ipLineEdit.text
                            network.openClient(ipLineEdit.text)
                            if (!network.isConnect()) {
                                canotConnectToServer.visible = true
                            } else if (network.isConnect()) {
                                stackview.push(gameArea)
                                gameArea.start()
                            }
                        }
                    }
                }
            }

            MyButton {
                //返回按钮
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
                    creatColumn.visible = false
                    joinColumn.visible = false
                    stackview.pop()
                    network.closeClient()
                    network.closeServer()
                    ipLineEdit.clear()
                }
            }
        }

        MessageDialog {
            //弹出提示对话框
            id: canotConnectToServer
            buttons: MessageDialog.Ok
            text: "无法连接到服务器"
            informativeText: "确保已经开启服务器"
            visible: false
            onOkClicked: visible = false
        }

        //-----消息提示框
        MessageDialog {
            id: invalidIPDialog
            buttons: MessageDialog.Ok
            text: "无效的IP地址"
            informativeText: "请输入正确的IP"
            visible: false
            onOkClicked: visible = false
        }
    }
}
