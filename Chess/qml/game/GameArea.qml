//Author:王梦娟 赵亚伟
//Last modification time：2018-07-05
import QtQuick 2.0
import VPlay 2.0
import QtQuick.Window 2.0
import ChessGame 1.0
import QtMultimedia 5.0

Item {
    //棋盘上的显示
    property var chessX: [] //定位
    property var chessY: []
    property var chess: [] //棋子数组
    readonly property double blockSize: 1 / 8 * width //棋子大小
    readonly property int rows: 10
    readonly property int columns: 9
    property alias gameBoard: gameBoard

    property int count: 0

    property bool gametype
    property bool myturn

    //判断是否轮到自己下棋
    property bool isend

    //判断游戏是否结束
    property int shanCount: 0
    property int redWinCount: 1
    property int blackWinCount: 1

    signal chesschlick(var x, var y)
    signal skinnumberChanged(var number)

    //皮肤切换
    BackgroundImage {
        id: bgImage
        anchors.fill: parent
        source: "qrc:/skins/skin" + setting.skinImageNumber + "/bg.png"
    }
    //游戏计时
    GameTimer {
        id: gameTimer
        x: 0.2 * parent.width
        width: 0.7 * parent.width
        height: 0.05 * parent.height
    }

    //棋盘
    GameBoard {
        id: gameBoard
        onShowChoose: {
            gameArea.chess[index(x, y)].showChoose()
        }
        onHideChoose: {
            gameArea.chess[index(x, y)].hideChoose()
        }
        onShowPath: {
            gameArea.chess[index(x, y)].showPath()
        }
        onHidePath: {
            gameArea.chess[index(x, y)].hidePath()
        }
        onShowPreviousPath: {
            gameArea.chess[index(x, y)].showpreviousPth()
        }
        onHidePerviousPath: {

            gameArea.chess[index(x, y)].hidepreviousPath()
        }

        //移动棋子
        onChessChange: {
            if (gameArea.chess[index(x1, y1)].type !== 0 && Math.floor(
                        gameArea.chess[index(x1, y1)].type / 8) === player)
                network.chessFromTheretoWhere(x1, y1, x2, y2)
            var value = gameArea.chess[index(x2, y2)]
            gameArea.chess[index(x1, y1)].move(x2, y2)
            value.move(x1, y1)
            gameArea.chess[index(x2, y2)] = gameArea.chess[index(x1, y1)]
            gameArea.chess[index(x1, y1)] = value
            movechessaudio.play()
            if (value.type !== 0) {
                value.died()
                movechessaudio.stop()
                eatchess.play()
            }
            count++
            myturn = false
        }
        //显示悔棋
        onChessBackChange: {
            var value = gameArea.chess[index(x2, y2)]
            value.type = type
            gameArea.chess[index(x1, y1)].move(x2, y2)
            value.move(x1, y1)
            gameArea.chess[index(x2, y2)] = gameArea.chess[index(x1, y1)]
            gameArea.chess[index(x1, y1)] = value
            count--
        }
        //游戏结束的动画加载
        onGameOver: {
            //end true赢了，false输了
            isend = end
            shanStart()
            console.log(shanZiTimer.running)
        }
    }

    //悔棋
    function back() {
        gameBoard.backChess()
        network.chessFromTheretoWhere(-1, -1, -1, -1)
    }

    //游戏结束时的动画图片以及定时器
    Timer {
        id: shanZiTimer
        repeat: true
        interval: 200
        onTriggered: {
            shanZi.source = "qrc:/interface/winOrLose/shan" + shanCount + ".png"
            shanCount++
            if (shanCount == 5) {
                shanCount = 0
                running = false
                if (gameBoard.player == 0) {
                    if (isend) {
                        blackWinStart()
                    } else if (!isend) {
                        redWinStart()
                    }
                }
                if (gameBoard.player == 1) {
                    if (isend) {
                        redWinStart()
                    } else if (!isend) {
                        blackWinStart()
                    }
                }
            }
        }
    }
    Timer {
        id: redWinTimer
        repeat: true
        interval: 250
        onTriggered: {
            redWin.source = "qrc:/interface/winOrLose/hong" + redWinCount + ".png"
            redWinCount++
            if (redWinCount == 3) {
                redWinCount = 0
                running = false
            }
        }
    }
    Timer {
        id: blackWinTimer
        repeat: true
        interval: 250
        onTriggered: {
            blackWin.source = "qrc:/interface/winOrLose/hei" + blackWinCount + ".png"
            blackWinCount++
            if (blackWinCount == 3) {
                blackWinCount = 0
                running = false
            }
        }
    }

    //游戏结束时加载的图片和动画
    Image {
        id: shanZi
        z: 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: false
        width: parent.width
        height: parent.height * 0.358
    }
    Image {
        id: redWin
        z: 11
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: false
        width: parent.width * 0.744
        height: parent.height * 0.17
    }
    Image {
        id: blackWin
        z: 11
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: false
        width: parent.width * 0.744
        height: parent.height * 0.17
    }

    //棋子移动的音频
    Audio {
        id: eatchess
        loops: 0
        source: "qrc:/interface/sound/heichi.wav"
    }
    Audio {
        id: movechessaudio
        loops: 0
        source: "qrc:/interface/sound/movechess.wav"
    }

    //游戏中的菜单
    GameMenu {
        id: gameMenu
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0.01 * height
        width: parent.width
        height: 0.15 * parent.height
    }

    onChesschlick: {
        if (myturn) {
            gameBoard.chlickChess(x, y)
        }
    }

    //布数记录
    onCountChanged: {
        gameTimer.countChanged(count)
    }
    onSkinnumberChanged: {
        initchess()
    }

    //初始化棋盘
    function initBoard() {
        positionCoord()
        for (var y = 0; y < rows; y++) {
            for (var x = 0; x < columns; x++) {
                chess[index(x, y)] = createBlock()
            }
        }
    }
    //返回棋子的索引
    function index(coordX, coordY) {
        return coordY * columns + coordX
    }

    //刷新棋盘，加载棋子
    function createField() {
        if (chess.length === 0) {
            initBoard()
        }
        count = 0
        gameTimer.stopTimer()
        gameTimer.timecount = 0
        gameBoard.chessClear()
        positionCoord()
        shanZi.visible = false
        redWin.visible = false
        blackWin.visible = false
        if (myturn === true) {
            gameBoard.player = 1
            gameBoard.loadChess(":/chess/red.txt")
        } else {
            gameBoard.player = 0
            gameBoard.loadChess(":/chess/black.txt")
        }
        initchess()
    }
    //初始化棋子
    function initchess() {
        for (var i = 0; i < gameBoard.chessCount(); i++) {
            var value = gameBoard.chessAt(i)
            chess[index(value.currentX, value.currentY)].type = -1
            chess[index(value.currentX, value.currentY)].type = value.type
            chess[index(value.currentX, value.currentY)].move(value.currentX,value.currentY)
            //chess[index(value.currentX, value.currentY)].coordX = value.currentX
            //chess[index(value.currentX, value.currentY)].coordY = value.currentY
        }
    }
    //游戏结束的动画开启
    function shanStart() {
        shanZi.visible = true
        shanZiTimer.start()
    }
    function redWinStart() {
        redWin.visible = true
        redWinTimer.start()
    }
    function blackWinStart() {
        blackWin.visible = true
        blackWinTimer.start()
    }
    //清楚棋盘上的棋子
    function removeField() {
        /*for (var i = 0; i < chess.length; i++) {
            var block = chess[i]
            chess[i] = null
        }
        chess.length = 0
        entityManager.removeAllEntities()*/
        gameBoard.chessClear()
        gameBoard.stackClear()
    }
    //创建棋子
    function createBlock() {
        var blockId = entityManager.createEntityFromUrl(Qt.resolvedUrl(
                                                            "Block.qml"))
        var block = entityManager.getEntityById(blockId)
        return block
    }
    function start() {
        myturn = network.isConnect()
        createField()
        gameTimer.startTimer()
    }
    //棋盘上的棋子定位
    function positionCoord() {
        chessX[0] = 0.064 * bgImage.width //0.108
        chessX[1] = 0.172 * bgImage.width //0.109
        chessX[2] = 0.281 * bgImage.width //0.108
        chessX[3] = 0.389 * bgImage.width //0.109
        chessX[4] = 0.498 * bgImage.width //0.108
        chessX[5] = 0.606 * bgImage.width //0.109
        chessX[6] = 0.715 * bgImage.width //0.108
        chessX[7] = 0.823 * bgImage.width //0.109
        chessX[8] = 0.932 * bgImage.width
        chessY[0] = 0.181 * bgImage.height //0.062
        chessY[1] = 0.243 * bgImage.height //0.061
        chessY[2] = 0.304 * bgImage.height //0.062
        chessY[3] = 0.366 * bgImage.height //0.061
        chessY[4] = 0.427 * bgImage.height //0.061
        chessY[5] = 0.488 * bgImage.height //0.062
        chessY[6] = 0.549 * bgImage.height //0.061
        chessY[7] = 0.611 * bgImage.height //0.062
        chessY[8] = 0.672 * bgImage.height //0.061
        chessY[9] = 0.734 * bgImage.height //0.062
    }
}
