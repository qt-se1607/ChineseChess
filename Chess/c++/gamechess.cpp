//Author:赵亚伟 王梦娟
//Last modification time：2018-07-01
#include "gamechess.h"

GameChess::GameChess(QObject *parent, int x, int y, int type)
    :QObject{parent}
{
    m_type=type;
    m_currentX=x;
    m_currentY=y;
    m_previousType=m_type;
}

GameChess::GameChess(GameChess *chess)
{
   m_currentX = chess->currentX();
   m_currentY = chess->currentY();
   m_previousX = chess->previousX();
   m_previousY = chess->previousY();
   m_type = chess->type();
   m_previousType = chess->previousType();
}

void GameChess::move(int x, int y)
{
    m_previousX=m_currentX;
    m_previousY=m_currentY;
    m_currentX=x;
    m_currentY=y;
}

int GameChess::currentX() const
{
    return m_currentX;
}

int GameChess::currentY() const
{
    return m_currentY;
}

int GameChess::previousX() const
{
    return m_previousX;
}

int GameChess::previousY() const
{
    return m_previousY;
}

int GameChess::type() const
{
    return m_type;
}

void GameChess::setType(int type)
{
    m_type = type;
}

void GameChess::chessDied()
{
    m_previousType=m_type;
    m_type=0;
}

int GameChess::previousType() const
{
    return m_previousType;
}
