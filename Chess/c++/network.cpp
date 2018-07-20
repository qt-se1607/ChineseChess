//Author:赵亚伟 张哲
//Last modification time：2018-07-05
#include "network.h"

NetWork::NetWork(QObject *parent)
    :QObject{parent}
{
    m_server = NULL;
    m_client =NULL;
}

NetWork::~NetWork()
{
    closeServer();
    closeClient();
}

QString NetWork::accessLocalIP()//获取本机IP
{
    QList<QHostAddress>ipAddressesList=QNetworkInterface::allAddresses();
    for(int i=0;i<ipAddressesList.size();++i){
        if(ipAddressesList.at(i)!=QHostAddress::LocalHost&&ipAddressesList.at(i).toIPv4Address()){
            m_ipAddress=ipAddressesList.at(i).toString();
            break;
        }
    }
    if(m_ipAddress.isEmpty())
        m_ipAddress=QHostAddress(QHostAddress::LocalHost).toString();
    return m_ipAddress;
}

void NetWork::openServer()//打开服务器
{
    if(m_server != NULL) closeServer();
    m_server = new QTcpServer(this);
    m_server->setMaxPendingConnections(1);//打开服务器
    qDebug()<<"opened";
    m_server->listen(QHostAddress::Any,PORT);
    if(!m_server->isListening()){
        qDebug()<<"listen failed.";
        exit(0);

    }
    connect(m_server,&QTcpServer::newConnection,[&](){//打开服务器所做操作
        emit successedConnected();
        m_client = m_server->nextPendingConnection();
        m_client->peerAddress();
        connect(m_client,&QTcpSocket::readyRead,[&](){
            QByteArray byteDate =  m_client->readAll();
            qDebug()<<byteDate;
            emit sendInformation(byteDate);//发送数据
            emit ismyturn();
        });
        qDebug()<<"connect";
    });
}

void NetWork::openClient(const QString ipAddress)//打开客户端
{
    if(m_client!=NULL) closeClient();
    m_client = new QTcpSocket(this);
    m_client->connectToHost(QHostAddress(ipAddress),PORT);//连接到服务器
    m_client->waitForConnected(TIMEOUT);
    connect(m_client,&QTcpSocket::readyRead,[&](){
        QByteArray byteDate =  m_client->readAll();
        qDebug()<<byteDate;
        emit sendInformation(byteDate);//发送数据
        emit ismyturn();
    });
}

void NetWork::closeServer()
{
    if(m_server==NULL) return ;
    m_server->close();
    delete m_server;
    m_server = NULL;
}

void NetWork::closeClient()
{
    if(m_client==NULL) return ;
    m_client->disconnectFromHost();
    m_client->waitForDisconnected(TIMEOUT);
    delete m_client;
    m_client = NULL;
}

void NetWork::chessFromTheretoWhere(int x1, int y1, int x2, int y2)//发送坐标到已连接设备
{
    QString date(QString::number(8-x1)+","+QString::number(9-y1)+","+QString::number(8-x2)+","+QString::number(9-y2));
    m_client->write(date.toLatin1());
    m_client->waitForBytesWritten(TIMEOUT);
}

bool NetWork::isConnect() const//是否已连接，留给qml判断的接口
{
    if(m_client==NULL)
        return false;
    if(m_client->state()==QAbstractSocket::ConnectedState ||m_client->state()==QAbstractSocket::ConnectingState)
        return true;
    else
        return false;
}
