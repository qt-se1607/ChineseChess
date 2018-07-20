//Author:王梦娟
//Last modification time：2018-06-28
import QtQuick 2.0

Item {
    //游戏中的菜单显示
    //设置
    Image {
        id: about
        width: 1 / 9 * parent.width
        height: 0.9 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 1 / 9 * parent.width
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/button/button.png"
        Image {
            id: settingImage
            anchors.fill: parent
            scale: 0.7
            source: "qrc:/skins/skin" + setting.skinImageNumber + "/settings/shezhi.png"
        }
        MultiPointTouchArea {
            anchors.fill: parent
            touchPoints: [
                TouchPoint {
                }
            ]
            onReleased: {
                stackview.push(setting)
            }
        }
    }
    //返回
    Image {
        id: leave
        width: 1 / 9 * parent.width
        height: 0.9 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 1 / 9 * parent.width
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/button/button.png"
        Image {
            id: returnImage
            anchors.fill: parent
            scale: 0.7
            source: "qrc:/skins/skin" + setting.skinImageNumber + "/settings/fanhui.png"
        }
        MultiPointTouchArea {
            anchors.fill: parent
            touchPoints: [
                TouchPoint {
                }
            ]
            onPressed: {
                gameArea.removeField()
            }
            onReleased: {
                stackview.pop()
            }
        }
    }
    //悔棋
    Image {
        id: reget
        width: 1 / 9 * parent.width
        height: 0.9 * parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: leave.left
        anchors.rightMargin: 1 / 4.5 * parent.width
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/button/button.png"
        Image {
            id: huiqiImage
            anchors.fill: parent
            scale: 0.7
            source: "qrc:/skins/skin" + setting.skinImageNumber + "/settings/huiqi.png"
        }
        MultiPointTouchArea {
            anchors.fill: parent
            touchPoints: [
                TouchPoint {
                }
            ]
            onReleased: {
                gameArea.back()
            }
        }
    }
}
