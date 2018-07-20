#include <QApplication>
#include <VPApplication>
#include <QQmlApplicationEngine>
#include "gameboard.h"
#include "gamechess.h"
#include "network.h"
#include "bluetooth.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    qmlRegisterType<GameBoard>("ChessGame",1,0,"GameBoard");
    qmlRegisterType<GameChess>("ChessGame",1,0,"GameChess");
    qmlRegisterType<NetWork>("network",1,0,"NetWork");
    qmlRegisterType<BlueTooth>("bluetooth",1,0,"BlueTooth");
    VPApplication vplay;
    QQmlApplicationEngine engine;
    vplay.initialize(&engine);
    vplay.setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml"));
    engine.load(QUrl(vplay.mainQmlFileName()));

    return app.exec();
}
