//Author:张哲
//Last modification time：2018-06-29
import QtQuick 2.0
import VPlay 2.0
import QtQuick.Controls 2.0
import QtMultimedia 5.0

Item {
    //设置菜单
    property string swticherSource
    property int skinImageNumber: 0 //皮肤号码
    property alias skinImage: skinPicture //用于留给外部访问待接口，尽量不要修改
    BackgroundImage {
        id: settingImage
        source: "qrc:/interface/mainInterface/setting.png"

        anchors.fill: parent
        Image {
            id: text1
            x: parent.width * (2 / 9)
            y: parent.height * 0.117
            width: 0.5 * parent.width
            height: 0.05 * parent.height
            source: "qrc:/interface/mainInterface/gameSetting.png"
        }
    }
    MyButton {
        x: parent.width * (6 / 7)
        y: parent.height * (1 / 17)
        width: parent.width * (1 / 17)
        height: parent.height * (1 / 19)
        source: "qrc:/interface/mainInterface/return.png"
        onChangedPage: {
            stackview.pop()
        }
    }

    //----------------------------------
    Image {
        x: parent.width * (1 / 20)
        width: 0.5 * parent.width
        height: 0.05 * parent.height
        y: parent.height * (2 / 6)
        id: soundSettingImage
        source: "qrc:/interface/mainInterface/soundSetting.png"
    }
    MyButton {
        id: soundSettingright
        x: parent.width * (8 / 9)
        y: parent.height * (2 / 6)
        width: 0.1 * parent.width
        height: 0.06 * parent.height
        source: "qrc:/interface/mainInterface/partright.png"
        onChangedPage: {
            if (audioManager.bgId.playing == true) {
                onOrOff.source = "qrc:/interface/mainInterface/switchoff.png"
                audioManager.bgId.pause()
            } else if (audioManager.bgId.playing == false) {
                onOrOff.source = "qrc:/interface/mainInterface/switchon.png"
                audioManager.bgId.play()
            }
        }
    }

    Image {
        y: parent.height * (2 / 6)
        x: parent.width * (4 / 6)
        width: 0.1 * parent.width
        height: 0.05 * parent.height
        source: "qrc:/interface/mainInterface/switchon.png"
        id: onOrOff
    }
    MyButton {
        id: soundSettingleft
        x: parent.width * (4 / 9)
        y: parent.height * (2 / 6)
        width: 0.1 * parent.width
        height: 0.06 * parent.height
        source: "qrc:/interface/mainInterface/partleft.png"
        onChangedPage: {
            if (audioManager.bgId.playing == true) {
                onOrOff.source = "qrc:/interface/mainInterface/switchoff.png"
                audioManager.bgId.pause()
            } else if (audioManager.bgId.playing == false) {
                onOrOff.source = "qrc:/interface/mainInterface/switchon.png"
                audioManager.bgId.play()
            }
        }
    }

    //-----------------------------------
    Image {
        y: parent.height * (4 / 6)
        x: parent.width * (1 / 20)
        width: 0.5 * parent.width
        height: 0.05 * parent.height
        id: skinSetting
        source: "qrc:/interface/mainInterface/skin.png"
    }
    MyButton {
        id: skinSettingleft
        x: parent.width * (4 / 9)
        y: skinSetting.y
        width: 0.1 * parent.width
        height: 0.06 * parent.height
        source: "qrc:/interface/mainInterface/partleft.png"
        onChangedPage: {
            if (skinImageNumber == 0)
                skinImageNumber = 3
            else
                skinImageNumber--

            //                string(skinImageNumber)
            skinPicture.source = "qrc:/interface/mainInterface/skin" + skinImageNumber + ".png"

            audioManager.musicChanged(
                        "qrc:/skins/skin" + setting.skinImageNumber + "/sounds/bg.mp3")
        }
    }
    Image {
        //皮肤图片
        id: skinPicture
        source: "qrc:/interface/mainInterface/skin" + skinImageNumber + ".png" //这个皮肤是竹林幽亭
        y: skinSetting.y
        x: parent.width * (5 / 9)
        width: 0.3 * parent.width
        height: 0.05 * parent.height
    }

    MyButton {
        id: skinSettingright
        x: parent.width * (8 / 9)
        y: skinSetting.y
        width: 0.1 * parent.width
        height: 0.06 * parent.height
        source: "qrc:/interface/mainInterface/partright.png"
        onChangedPage: {
            if (skinImageNumber == 3)
                skinImageNumber = 0
            else
                skinImageNumber++

            //                string(skinImageNumber)
            skinPicture.source = "qrc:/interface/mainInterface/skin" + skinImageNumber + ".png"
            audioManager.musicChanged(
                        "qrc:/skins/skin" + setting.skinImageNumber + "/sounds/bg.mp3")
        }
    }
    onSkinImageNumberChanged: {
        gameArea.skinnumberChanged(skinImageNumber)
    }
}
