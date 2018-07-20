//Author:赵亚伟 王梦娟
//Last modification time：2018-07-05
#ifndef GAMEBOARD_H
#define GAMEBOARD_H

#define ROWS 10//行数
#define COLUMNS 9//列数

#include <QObject>
#include <QList>
#include <QQmlListProperty>
#include <QMap>
#include <QStack>

class GameChess;

typedef QMap<int,QMap<int,GameChess*>> Map;

class GameBoard:public QObject//用于游戏规则计算和棋子储存
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<GameChess> chess READ chess)
    Q_PROPERTY(int player READ player WRITE setPlayer)//当前玩家的身份
public:
    GameBoard(QObject *parent=0);
    QQmlListProperty<GameChess> chess();
    ~GameBoard();

    Q_INVOKABLE void loadChess(const QString &filename);//从文件初始化棋子
    Q_INVOKABLE void goChess(QString data);//对手的操作
    Q_INVOKABLE void backChess();//悔棋
    Q_INVOKABLE void stackClear();//清空下棋的记录

    Q_INVOKABLE void chessAppend(GameChess *chess);//qml和c++的QList交互
    Q_INVOKABLE int chessCount()const;
    Q_INVOKABLE GameChess *chessAt(int index) const;
    Q_INVOKABLE void chessClear();

    int player() const;
    void setPlayer(int player);

signals:
    void chlickChess(const int x,const int y);//当前选中棋子
    void showChoose(const int x,const int y);//显示选中框
    void hideChoose(const int x,const int y);//隐藏选中框
    void showPath(const int x,const int y);//显示当前棋子的可行路径
    void hidePath(const int x,const int y);//隐藏当前棋子的可行路径
    void chessChange(const int x1,const int y1,const int x2,const int y2);//交换棋子
    void chessBackChange(const int x1,const int y1,const int x2,const int y2,const int type);//悔棋交换
    void currentChessChanged();//切换当前棋子
    void showPreviousPath(const int x,const int y);//显示双方操作路径
    void hidePerviousPath(const int x,const int y);//隐藏双方操作路径
    void gameOver(bool end);//游戏结束
private:
    static void chessAppend(QQmlListProperty<GameChess>*list, GameChess* chess);
    static int chessCount(QQmlListProperty<GameChess>*list);
    static GameChess *chessAt(QQmlListProperty<GameChess> *list, int index);
    static void chessClear(QQmlListProperty<GameChess> *list);

    GameChess *currentChess() const;
    void setCurrentChess(GameChess *currentChess);
    void findPath();
    bool findChess(Map *chess,int x,int y);
    void clearPath();
    void Chess0();//兵/卒
    void Chess1();//车
    void Chess2();//马
    void Chess3();//象
    void Chess4();//士
    void Chess5();//帅/将
    void Chess6();//炮
    bool isEat(GameChess *value);
    void change(const int x1,const int y1,const int x2,const int y2);

    QList<GameChess*> m_chess;
    Map m_map;
    Map m_path;
    GameChess *m_currentChess;
    int m_player;
    QStack<GameChess *> stack1;
    QStack<GameChess *> stack2;
};

#endif // GAMEBOARD_H
