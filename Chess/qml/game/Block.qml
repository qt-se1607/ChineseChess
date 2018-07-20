//Author:王梦娟 赵亚伟
//Last modification time：2018-07-05
import VPlay 2.0
import QtQuick 2.0
import QtGraphicalEffects 1.0
import ChessGame 1.0


/*
 *黑     |*
 *车 1   |*车 8
 *马 2   |*马 9
 *象 3   |*相 10
 *士 4   |*仕 11
 *将 5   |*帅 12
 *炮 6   |*炮 13
 *卒 7   |*兵 14
 */
EntityBase {
    //棋盘棋子的加载与显示
    property int type: -1
    property int coordX: -1
    property int coordY: -1
    readonly property double blockSize: 1 / 8 * parent.width

    property int countpath: 0

    id: block
    entityType: "block"
    poolingEnabled: true
    width: blockSize
    height: blockSize
    enabled: opacity == 1

    Item {
        anchors.fill: parent
        Rectangle {
            id: round
            width: 0.8 * parent.width
            height: 0.8 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            radius: width / 2
            visible: false
        }
        //棋子皮肤
        Image {
            id: image
            visible: false
            source: "qrc:/skins/skin" + setting.skinImageNumber + "/qizi/chess" + type + ".png"
        }
        //触屏事件响应
        OpacityMask {
            visible: true
            anchors.fill: round
            source: image
            maskSource: round
            MultiPointTouchArea {
                anchors.fill: parent
                touchPoints: [
                    TouchPoint {
                    }
                ]
                onPressed: {
                    gameArea.chesschlick(coordX, coordY)
                }
            }
        }
        //点击棋子出现的选中框
        Image {
            id: choose
            source: "qrc:/interface/board2.png"
            anchors.fill: round
            visible: false
        }
        //选中棋子出现的路径
        Image{
            id: path
            visible: false
            width: 0.2 * round.width
            height: 0.2 * round.height
            anchors.verticalCenter: round.verticalCenter
            anchors.horizontalCenter: round.horizontalCenter

            source: {
                if (type == 0)
                    return "qrc:/interface/path/blackpoint.png"
                else
                    return "qrc:/interface/path/redpoint.png"
            }
            onVisibleChanged: {
                if (type != 0)
                    pathchess.visible = visible
            }
        }
        //若棋子的路径上有可以吃掉的棋子，用红色的圈标识
        Image {
            id: pathchess
            visible: false
            source: "qrc:/interface/path/move_path0.png"
            anchors.fill: parent
            onVisibleChanged: {
                if (visible)
                    passc.start()
                else
                    passc.stop()
            }
        }
        //红色圈的动画
        NumberAnimation {
            id: passc
            target: pathchess
            property: "rotation"
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: 1000
        }
        //棋子移动后之前的路径显示以及动画
        Image {
            id: previousPath
            visible: false
            source: "qrc:/interface/path/before_path0.png"
            anchors.fill: round
        }
        NumberAnimation {
            id: previous
            target: previousPath
            property: "rotation"
            loops: Animation.Infinite
            from: 0
            to: 360
            duration: 1000
        }
    }
    //重新进入棋局时重新隐藏路径显示等图片
    onTypeChanged: {
        image.source = imageSource()
        if (type === -1) {
            choose.visible = false
            path.visible = false
            pathchess.visible = false
            previousPath.visible = false
            passc.stop()
            previous.stop()
        }
    }

    //棋子移动时的坐标显示
    ParallelAnimation {
        id: animation
        NumberAnimation {
            target: block
            property: "x"
            to: gameArea.chessX[coordX] - 0.5 * width
            duration: 333
        }
        NumberAnimation {
            target: block
            property: "y"
            to: gameArea.chessY[coordY] - 0.5 * height
            duration: 333
        }
    }
    //延时器
    Timer{
        id:showPathTimer
        interval: 300
        onTriggered: {
            previousPath.visible = true
            previous.start()
        }
    }
    Timer{
        id:hidePathTimer
        interval: 300
        onTriggered: {
            previousPath.visible = false
            previous.stop()
        }
    }

    //控制路径图片的显示与隐藏
    function showChoose() {
        choose.visible = true
    }
    function hideChoose() {
        choose.visible = false
    }
    function showPath() {
        path.visible = true
    }
    function hidePath() {
        path.visible = false
    }
    function showpreviousPth() {
        showPathTimer.start()
    }
    function hidepreviousPath() {
        hidePathTimer.start()
    }
    function imageSource() {
        return "qrc:/skins/skin" + setting.skinImageNumber + "/qizi/chess" + type + ".png"
    }
    //棋子死亡的判断
    function died() {
        type = 0
    }
    //棋子移动
    function move(X, Y) {
        coordX = X
        coordY = Y
        choose.visible = false
        animation.start()
    }
}
