//Author:赵亚伟 王梦娟
//Last modification time：2018-07-05
#include <QFile>
#include <QDebug>
#include <QString>
#include <QStringList>
#include "gameboard.h"
#include "gamechess.h"


GameBoard::GameBoard(QObject *parent)
    :QObject{parent}
{
    m_currentChess=NULL;
    connect(this,&GameBoard::currentChessChanged,[&](){
        if(currentChess()!=NULL){
            findPath();
        }
        else{
            clearPath();
        }
    });
    connect(this,&GameBoard::chlickChess,[&](const int x,const int y){
        if(findChess(&m_map,x,y)){
            if(m_map[x][y]->type()==0){
                if(currentChess()!=NULL&&findChess(&m_path,x,y)){
                    clearPath();
                    emit chessChange(currentChess()->currentX(),currentChess()->currentY(),x,y);
                    change(currentChess()->currentX(),currentChess()->currentY(),x,y);
                    setCurrentChess(NULL);
                }
            }
            else if(m_map[x][y]->type()/8==player()){
                if(currentChess()==NULL){
                    setCurrentChess(m_map[x][y]);
                    emit showChoose(x,y);
                }
                else if(currentChess()->currentX()==x&&currentChess()->currentY()==y){
                    setCurrentChess(NULL);
                    emit hideChoose(x,y);
                }
                else{
                    emit hideChoose(currentChess()->currentX(),currentChess()->currentY());
                    setCurrentChess(m_map[x][y]);
                    emit showChoose(x,y);
                }
            }
            else if(findChess(&m_path,x,y)&&currentChess()!=NULL){
                clearPath();
                emit chessChange(currentChess()->currentX(),currentChess()->currentY(),x,y);
                change(currentChess()->currentX(),currentChess()->currentY(),x,y);
                setCurrentChess(NULL);
            }
        }
    });
}

QQmlListProperty<GameChess> GameBoard::chess()
{
    return QQmlListProperty<GameChess>(this,0,&GameBoard::chessAppend,&GameBoard::chessCount,&GameBoard::chessAt,&GameBoard::chessClear);
}

GameBoard::~GameBoard()
{
    stackClear();
    for(auto i:m_chess){
        if(i!=NULL)delete i;
    }
}

void GameBoard::loadChess(const QString &filename)
{
    if(chessCount()!=0){
        for(auto i : m_chess)
            delete i;
        chessClear();
    }
    for(int y=0;y<ROWS;y++){
        for(int x=0;x<COLUMNS;x++){
            GameChess *value=new GameChess(this,x,y,0);
            chessAppend(value);
            m_map[x][y]=value;
        }
    }
    QFile file(filename);
    if(!file.open(QFile::ReadOnly | QFile::Text))
    {
        qDebug() << " Could not open the file for reading";
        return;
    }

    QTextStream in(&file);
    while(!in.atEnd()){
        QString myText = in.readLine();
        QStringList listText=myText.split(',');
        m_map[listText[0].toInt()][listText[1].toInt()]->setType(listText[2].toInt());
    }
    file.close();
}

void GameBoard::chessAppend(GameChess *chess)
{
    m_chess.append(chess);
}

int GameBoard::chessCount() const
{
    return m_chess.count();
}

GameChess *GameBoard::chessAt(int index) const
{
    return m_chess.at(index);
}

void GameBoard::chessClear()
{
    m_chess.clear();
}

void GameBoard::goChess(QString data)
{
    QStringList position= data.split(',');
    int x1 = position[0].toInt();
    int y1 = position[1].toInt();
    int x2 = position[2].toInt();
    int y2 = position[3].toInt();
    if((x1==x2)&&(x1==COLUMNS)&&(y1==y2)&&(y2==ROWS)){
        backChess();
        return;
    }
    emit chessChange(x1,y1,x2,y2);
    if(stack1.count() !=0){
        auto tmp = stack1.top();
        emit hidePerviousPath(tmp->currentX(),tmp->currentY());
    }
    auto tmpchess1 = new GameChess(m_map[x1][y1]);
    stack1.push(tmpchess1);
    auto tmpchess2 = new GameChess(m_map[x2][y2]);
    stack2.push(tmpchess2);
    emit showPreviousPath(tmpchess1->currentX(),tmpchess1->currentY());

    if(m_map[x2][y2]->type() == player() * 7 + 5)
        emit gameOver(false);

    GameChess *currentChess = m_map[x1][y1];
    if(m_map[x2][y2]->type()!=0)m_map[x2][y2]->chessDied();
    m_map[x1][y1]->move(x2,y2);
    m_map[x2][y2]->move(x1,y1);

    m_map[x1][y1]=m_map[x2][y2];
    m_map[x2][y2]=currentChess;
}

void GameBoard::backChess()
{
    if(stack1.count()!=0&&stack2.count()!=0){
    GameChess *chess1=stack1.pop();
    GameChess *chess2=stack2.pop();
    emit hidePerviousPath(chess1->currentX(),chess1->currentY());
    emit chessBackChange(chess2->currentX(),chess2->currentY(),chess1->currentX(),chess1->currentY(),chess2->type());
    delete m_map[chess1->currentX()][chess1->currentY()];
    delete m_map[chess2->currentX()][chess2->currentY()];
    m_map[chess1->currentX()][chess1->currentY()]=chess1;
    m_map[chess2->currentX()][chess2->currentY()]=chess2;
    if(stack1.count() !=0){
        auto tmp = stack1.top();
        emit showPreviousPath(tmp->currentX(),tmp->currentY());
    }
    }
}

void GameBoard::stackClear()
{
    for(auto i:stack1)
        if(i!=NULL)delete i;
    stack1.clear();
    for(auto i:stack2)
        if(i!=NULL)delete i;
    stack2.clear();
    m_currentChess = NULL;
    m_path.clear();
}

void GameBoard::chessAppend(QQmlListProperty<GameChess> *list, GameChess *chess)
{
    qobject_cast<GameBoard*>(list->object)->chessAppend(chess);
}

int GameBoard::chessCount(QQmlListProperty<GameChess> *list)
{
    return qobject_cast<GameBoard*>(list->object)->chessCount();
}

GameChess *GameBoard::chessAt(QQmlListProperty<GameChess> *list, int index)
{
    return qobject_cast<GameBoard*>(list->object)->chessAt(index);
}

void GameBoard::chessClear(QQmlListProperty<GameChess> *list)
{
    qobject_cast<GameBoard*>(list->object)->chessClear();
}

GameChess *GameBoard::currentChess() const
{
    return m_currentChess;
}

void GameBoard::setCurrentChess(GameChess *currentChess)
{
    m_currentChess = currentChess;
    emit currentChessChanged();
}

void GameBoard::findPath()
{
    clearPath();
    switch(currentChess()->type()%7){
        case 0:Chess0();break;
        case 1:Chess1();break;
        case 2:Chess2();break;
        case 3:Chess3();break;
        case 4:Chess4();break;
        case 5:Chess5();break;
        case 6:Chess6();break;
    }
    for(auto x:m_path){
        for(auto y:x){
            emit showPath(y->currentX(),y->currentY());
        }
    }
}

bool GameBoard::findChess(Map *chess,int x,int y)
{
    auto z = chess->find(x);
    if(z==chess->end())
        return false;
    else if((*z).find(y)==(*z).end())
        return false;
    return true;
}

void GameBoard::clearPath()
{
    if(m_path.count() != 0){
        for(auto x:m_path){
            for(auto y:x){
                  emit hidePath(y->currentX(),y->currentY());
            }
        }
    }
    m_path.clear();
}

void GameBoard::Chess0()
{
    int X=currentChess()->currentX();
    int Y=currentChess()->currentY();
    if (Y<5){
        if(isEat(m_map[X-1][Y]))
            m_path[X-1][Y]=m_map[X-1][Y];
        if(isEat(m_map[X+1][Y]))
            m_path[X+1][Y]=m_map[X+1][Y];
    }
    if(isEat(m_map[X][Y-1]))
        m_path[X][Y-1]=m_map[X][Y-1];
}

void GameBoard::Chess1()
{
    int X=currentChess()->currentX();
    int Y=currentChess()->currentY();
    for(int i=X;i<COLUMNS;i++){
        if(i==X)continue;
        if(isEat(m_map[i][Y]))
            m_path[i][Y]=m_map[i][Y];
        if(m_map[i][Y]->type()!=0)break;
    }
    for(int i=X;i>=0;i--){
        if(i==X)continue;
        if(isEat(m_map[i][Y]))
            m_path[i][Y]=m_map[i][Y];
        if(m_map[i][Y]->type()!=0)break;
    }
    for(int i=Y;i<ROWS;i++){
        if(i==Y)continue;
        if(isEat(m_map[X][i]))
            m_path[X][i]=m_map[X][i];
        if(m_map[X][i]->type()!=0)break;
    }
    for(int i=Y;i>=0;i--){
        if(i==Y)continue;
        if(isEat(m_map[X][i]))
            m_path[X][i]=m_map[X][i];
        if(m_map[X][i]->type()!=0)break;
    }
}

void GameBoard::Chess2()
{
    int X=currentChess()->currentX();
    int Y=currentChess()->currentY();
    if(m_map[X-1][Y]&&m_map[X-1][Y]->type()==0){
        if(isEat(m_map[X-2][Y-1]))m_path[X-2][Y-1]=m_map[X-2][Y-1];
        if(isEat(m_map[X-2][Y+1]))m_path[X-2][Y+1]=m_map[X-2][Y+1];
    }
    if(m_map[X+1][Y]&&m_map[X+1][Y]->type()==0){
        if(isEat(m_map[X+2][Y-1]))m_path[X+2][Y-1]=m_map[X+2][Y-1];
        if(isEat(m_map[X+2][Y+1]))m_path[X+2][Y+1]=m_map[X+2][Y+1];
    }
    if(m_map[X][Y-1]&&m_map[X][Y-1]->type()==0){
        if(isEat(m_map[X-1][Y-2]))m_path[X-1][Y-2]=m_map[X-1][Y-2];
        if(isEat(m_map[X+1][Y-2]))m_path[X+1][Y-2]=m_map[X+1][Y-2];
    }
    if(m_map[X][Y+1]&&m_map[X][Y+1]->type()==0){
        if(isEat(m_map[X-1][Y+2]))m_path[X-1][Y+2]=m_map[X-1][Y+2];
        if(isEat(m_map[X+1][Y+2]))m_path[X+1][Y+2]=m_map[X+1][Y+2];
    }
}

void GameBoard::Chess3()
{
    int X=currentChess()->currentX();
    int Y=currentChess()->currentY();
    if(Y/5==(Y-2)/5){
        if(m_map[X-1][Y-1]&&m_map[X-1][Y-1]->type()==0)
            if(isEat(m_map[X-2][Y-2]))m_path[X-2][Y-2]=m_map[X-2][Y-2];
        if(m_map[X+1][Y-1]&&m_map[X+1][Y-1]->type()==0)
            if(isEat(m_map[X+2][Y-2]))m_path[X+2][Y-2]=m_map[X+2][Y-2];
    }
    if(Y/5==(Y+2)/5){
        if(m_map[X+1][Y+1]&&m_map[X+1][Y+1]->type()==0)
            if(isEat(m_map[X+2][Y+2]))m_path[X+2][Y+2]=m_map[X+2][Y+2];
        if(m_map[X-1][Y+1]&&m_map[X-1][Y+1]->type()==0)
            if(isEat(m_map[X-2][Y+2]))m_path[X-2][Y+2]=m_map[X-2][Y+2];
    }
}

void GameBoard::Chess4()
{
    int X=currentChess()->currentX();
    int Y=currentChess()->currentY();
    if(X>3&&Y>7&&isEat(m_map[X-1][Y-1]))
        m_path[X-1][Y-1]=m_map[X-1][Y-1];
    if(X<5&&Y<9&&isEat(m_map[X+1][Y+1]))
        m_path[X+1][Y+1]=m_map[X+1][Y+1];
    if(X>3&&Y<9&&isEat(m_map[X-1][Y+1]))
        m_path[X-1][Y+1]=m_map[X-1][Y+1];
    if(X<5&&Y>7&&isEat(m_map[X+1][Y-1]))
        m_path[X+1][Y-1]=m_map[X+1][Y-1];
}

void GameBoard::Chess5()
{
    int X=currentChess()->currentX();
    int Y=currentChess()->currentY();
    if(X>3&&isEat(m_map[X-1][Y]))
        m_path[X-1][Y]=m_map[X-1][Y];
    if(X<5&&isEat(m_map[X+1][Y]))
        m_path[X+1][Y]=m_map[X+1][Y];
    if(Y<9&&isEat(m_map[X][Y+1]))
        m_path[X][Y+1]=m_map[X][Y+1];
    if(Y>7&&isEat(m_map[X][Y-1]))
        m_path[X][Y-1]=m_map[X][Y-1];
}

void GameBoard::Chess6()
{
    int X=currentChess()->currentX();
    int Y=currentChess()->currentY();
    for(int i=X;i<COLUMNS;i++){
        if(i==X)continue;
        if(m_map[i][Y]->type()!=0){
            for(int j=i;j<COLUMNS;j++){
                if(j==i)continue;
                if(isEat(m_map[j][Y])&&m_map[j][Y]->type()!=0){
                    m_path[j][Y]=m_map[j][Y];
                    break;
                }
                if(m_map[j][Y]->type()!=0)
                    break;
            }
            break;
        }
        else if(isEat(m_map[i][Y]))
            m_path[i][Y]=m_map[i][Y];
    }
    for(int i=X;i>=0;i--){
        if(i==X)continue;
        if(m_map[i][Y]->type()!=0){
            for(int j=i;j>=0;j--){
                if(j==i)continue;
                if(isEat(m_map[j][Y])&&m_map[j][Y]->type()!=0){
                    m_path[j][Y]=m_map[j][Y];
                    break;
                }
                if(m_map[j][Y]->type()!=0)
                    break;
            }
            break;
        }
        else if(isEat(m_map[i][Y]))
            m_path[i][Y]=m_map[i][Y];
    }
    for(int i=Y;i<ROWS;i++){
        if(i==Y)continue;
        if(m_map[X][i]->type()!=0){
            for(int j=i;j<ROWS;j++){
                if(j==i)continue;
                if(isEat(m_map[X][j])&&m_map[X][j]->type()!=0){
                    m_path[X][j]=m_map[X][j];
                    break;
                }
                if(m_map[X][j]->type()!=0)
                    break;
            }
            break;
        }
        else if(isEat(m_map[X][i]))
            m_path[X][i]=m_map[X][i];
    }
    for(int i=Y;i>=0;i--){
        if(i==Y)continue;
        if(m_map[X][i]->type()!=0){
            for(int j=i;j>=0;j--){
                if(j==i)continue;
                if(isEat(m_map[X][j])&&m_map[X][j]->type()!=0){
                    m_path[X][j]=m_map[X][j];
                    break;
                }
                if(m_map[X][j]->type()!=0)
                    break;
            }
            break;
        }
        else if(isEat(m_map[X][i]))
            m_path[X][i]=m_map[X][i];
    }
}

bool GameBoard::isEat(GameChess *value)
{
    if(value==NULL)return false;
    if(value->type()==0)return true;
    if(value->type()/8==player())return false;
    return true;
}

void GameBoard::change(const int x1, const int y1, const int x2, const int y2)
{
    if(stack1.count() !=0){
        auto tmp = stack1.top();
        emit hidePerviousPath(tmp->currentX(),tmp->currentY());
    }
    auto tmpchess1 = new GameChess(m_map[x1][y1]);
    stack1.push(tmpchess1);
    auto tmpchess2 = new GameChess(m_map[x2][y2]);
    stack2.push(tmpchess2);
    emit showPreviousPath(tmpchess1->currentX(),tmpchess1->currentY());

    if(m_map[x2][y2]->type() == (1-player()) * 7 + 5)
        emit gameOver(true);

    if(m_map[x2][y2]->type()!=0)m_map[x2][y2]->chessDied();
    m_map[x1][y1]->move(x2,y2);
    m_map[x2][y2]->move(x1,y1);

    m_map[x1][y1]=m_map[x2][y2];
    m_map[x2][y2]=currentChess();
}

int GameBoard::player() const
{
    return m_player;
}

void GameBoard::setPlayer(int player)
{
    m_player = player;
}
