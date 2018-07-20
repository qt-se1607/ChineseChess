//Author:赵亚伟 张哲
//Last modification time：2018-07-01
#include "bluetooth.h"
#include <QtQuick>
using namespace::std;
//建立一个存储UUid的机制，采用串口模式
static const QLatin1String serviceUuid("00001101-0000-1000-8000-00805F9B34FB");

BlueTooth::BlueTooth(QObject *parent) :
    QObject(parent)
{
    discoveryAgent = new QBluetoothDeviceDiscoveryAgent();
    localDevice = new QBluetoothLocalDevice();
    socket = new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol);
    //设置搜索模式
    discoveryAgent->setInquiryType(QBluetoothDeviceDiscoveryAgent::LimitedInquiry);
    discoveryAgent->start();
    //蓝牙设备进行查找,当找到设备，发送下面这个信号
    connect(discoveryAgent,&QBluetoothDeviceDiscoveryAgent::deviceDiscovered,this,&BlueTooth::scanAndAddDeviceLists);
//    connect(socket,SIGNAL(readyRead()),this,SLOT(readBluetoothDataEvent()));
    //判断蓝牙是否打开，从而对按钮进行disabled操作
    if(localDevice->hostMode() == QBluetoothLocalDevice::HostPoweredOff)
        openOrNotBluetooth = true;

    //检测蓝牙是否可以被其他蓝牙设备搜索到
    if(localDevice->hostMode()==QBluetoothLocalDevice::HostDiscoverable)
        canBeDetect = true;
}
BlueTooth::~BlueTooth()
{
    delete socket;
    delete discoveryAgent;
    delete localDevice;
}
//将发现的设备用list打印到这个列表中
void BlueTooth::scanAndAddDeviceLists(const QBluetoothDeviceInfo &info )
{
    QString color;

    //如果列表不为空
        //如果蓝牙设备列表不为空,Paired已配对，UnPaired配对失败,AutoPaired自动配对并授权
    qDebug()<<info.name()<<" "<<info.address();
        QBluetoothLocalDevice::Pairing pairingStatus = localDevice->pairingStatus(info.address());
//        如果蓝牙配对成功，或者自动配对
        if (pairingStatus == QBluetoothLocalDevice::Paired || pairingStatus == QBluetoothLocalDevice::AuthorizedPaired)
        {
            qDebug()<<"已经连接";
            color = "green";
        }
        else
        {
            qDebug()<<"授权失败";
            color = "gray";
        }
        emit findDifferentDevice(info.name(),info.address().toString(),color);

}


void BlueTooth::openBluetooth()
{
    localDevice->powerOn();//打开蓝牙
}
void BlueTooth::connectOK()
{
    discoveryAgent->stop();  //停止搜索设备
}
void BlueTooth::scan()
{
    discoveryAgent->setInquiryType(QBluetoothDeviceDiscoveryAgent::LimitedInquiry);
    discoveryAgent->start();
}


void BlueTooth::on_pushButton_closeDevice_clicked()
{
    //关闭蓝牙设备，同打开蓝牙设备不同。
    localDevice->setHostMode(QBluetoothLocalDevice::HostPoweredOff);
}

void BlueTooth::establshConnect(QString address)
{

    qDebug() << "You has choice the bluetooth address is " << address;
    qDebug() << "The device is connneting.... ";
    //获得地址信息,返回包含字符串的n个最左边字符的子字符串。如果n大于或等于size（）或小于零，则返回整个字符串。
    //将地址和蓝牙模式传进来
    QBluetoothAddress add(address);
    socket->connectToService(add, QBluetoothUuid(serviceUuid) ,QIODevice::ReadWrite);

}

//void BlueTooth::readBluetoothDataEvent()
//{

//    QByteArray line = socket->readAll();
//    QString strData = line.toHex();
//    comStr.append(strData);
//    qDebug() <<"rec data is: "<< comStr;
//    qDebug() <<"The comStr length is: " << comStr.length();
//    if(comStr.length() >= 30) {

//        //将蓝牙读取到待数据显示在qml上
//        ui->textBrowser_info->append(comStr + "\n");
//        comStr.clear();
//    }

//}

//断开连接
void BlueTooth::disconnect()
{
    socket->disconnectFromService();
}
void BlueTooth::sendMessage(QString information)
{
    QByteArray arrayData;//声明位数组
    arrayData = information.toUtf8();
    socket->write(arrayData);//发送数据
}

bool BlueTooth::isOpenOrNot()
{
    if(localDevice->hostMode() == QBluetoothLocalDevice::HostPoweredOff)
        return false;
    else
        return true;
}


