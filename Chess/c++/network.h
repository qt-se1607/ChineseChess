//Author:赵亚伟 张哲
//Last modification time：2018-07-05
#ifndef NETWORK_H
#define NETWORK_H

#include <QtNetwork>
#include <QObject>

#define PORT 6666
#define TIMEOUT 100

class NetWork:public QObject
{
    Q_OBJECT
public:
    explicit NetWork(QObject *parent=0);
    ~NetWork();
    Q_INVOKABLE QString accessLocalIP();//获取本机IP
    Q_INVOKABLE void openServer();//打开服务器
    Q_INVOKABLE void openClient(const QString ipAddress);//打开客户端
    Q_INVOKABLE void closeServer();//关闭服务器
    Q_INVOKABLE void closeClient();//关闭客户端
    Q_INVOKABLE void chessFromTheretoWhere(int x1,int y1,int x2,int y2);//发送棋子移动信息
    Q_INVOKABLE bool isConnect() const;//是否连接
signals:
    void sendInformation(const QString str);//
    void successedConnected();//连接成功
    void ismyturn();//当前出棋方
private:
    QTcpServer *m_server;
    QTcpSocket *m_client;
    QString m_ipAddress;
};
#endif // NETWORK_H
