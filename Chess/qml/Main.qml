//author：赵亚伟 张哲 王梦娟
import VPlay 2.0
import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Controls 2.0
import "./interface"
import "./game"
import network 1.0

GameWindow {
    id: gameWindow

    activeScene: scene
    screenWidth: 9 / 16 * Screen.desktopAvailableHeight
    screenHeight: Screen.desktopAvailableHeight
    onSplashScreenFinished: {
        mainItem.start()
        gameArea.initBoard()
    }

    Setting {
        id: setting
    }
    AudioManager {
        //音频管理
        id: audioManager
    }
    MainInterface {
        id: mainItem
    }

    EntityManager {
        id: entityManager
        entityContainer: gameArea
    }

    GameArea {
        id: gameArea
    }

    AboutProgram {
        id: about
    }

    FightOption {
        id: fightOption
    }

    NetSocket {
        id: netSocket
    }

    BluetoothConnect {
        id: blueConnect
    }

    Scene {
        anchors.fill: parent
        id: scene

        StackView {
            //栈视图实现页面的切换
            id: stackview
            anchors.fill: parent
            initialItem: mainItem
        }
    }

    NetWork {
        id: network
        onSendInformation: {
            gameArea.gameBoard.goChess(str) //传进来的数据进行移动棋子
        }
        onIsmyturn: {
            gameArea.myturn = true
        }
        onSuccessedConnected: {
            //成功连接直接打开游戏
            stackview.push(gameArea)
            gameArea.start()
        }
    }
}
