//Author:赵亚伟 王梦娟
//Last modification time：2018-07-01
#ifndef GAMECHESS_H
#define GAMECHESS_H

#include <QObject>
#include <QMap>

class GameChess:public QObject//棋子
{
    Q_OBJECT
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
    Q_PROPERTY(int type READ type)//棋子类型
    Q_PROPERTY(int currentX READ currentX)//当前坐标
    Q_PROPERTY(int currentY READ currentY)
    Q_PROPERTY(int previousX READ previousX)//先前坐标
    Q_PROPERTY(int previousY READ previousY)
public:
    GameChess(QObject *parent=0, int x=0, int y=0,int type=0);
    GameChess(GameChess *chess);

    void move(int x, int y);//移动
    int currentX() const;
    int currentY() const;
    int previousX() const;
    int previousY() const;
    int type() const;
    void setType(int type);
    void chessDied();//棋子阵亡
    int previousType() const;

private:
    int m_currentX;
    int m_currentY;
    int m_previousX;
    int m_previousY;
    int m_type;
    int m_previousType;
};

#endif // GAMECHESS_H
