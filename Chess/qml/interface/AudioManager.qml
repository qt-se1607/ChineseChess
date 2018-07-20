//Author:张哲
//Last modification time：2018-06-28
import VPlay 2.0
import QtQuick 2.0
import QtMultimedia 5.0

Scene {
    //背景音乐
    property bool bgMusicStatus: bgMusic.playing
    property alias bgId: bgMusic
    signal musicChanged(var musicpath)
    anchors.fill: parent
    BackgroundMusic {
        id: bgMusic
        source: "qrc:/skins/skin" + 0 + "/sounds/bg.mp3"
    }
    onMusicChanged: {
        bgMusic.stop()
        bgMusic.source = musicpath
        bgMusic.play()
    }
}
