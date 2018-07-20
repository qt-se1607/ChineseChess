//Author:赵亚伟 张哲
//Last modification time：2018-07-01
#ifndef BLUETOOTH_H
#define BLUETOOTH_H
#include <QtBluetooth>
class BlueTooth:public QObject
{
    Q_OBJECT
public:
    explicit BlueTooth(QObject *parent = 0);
    ~BlueTooth();


    Q_INVOKABLE void scan();
//    Q_INVOKABLE void clearListDevice();//清理设备列表
    Q_INVOKABLE void establshConnect(QString address);//建立连接
//    Q_INVOKABLE void openServer();
    Q_INVOKABLE void connectOK();//连接成功
    Q_INVOKABLE void disconnect();//断开连接
    Q_INVOKABLE void sendMessage(QString information);//发送讯息
    Q_INVOKABLE bool isOpenOrNot();//蓝牙是否打开
signals:
    void findDifferentDevice(QString name,QString address,QString color);//搜到不同的蓝牙
private slots:
    void scanAndAddDeviceLists(const QBluetoothDeviceInfo&);
    void openBluetooth();
    void on_pushButton_closeDevice_clicked();
//    void readBluetoothDataEvent();//读取蓝牙传过来待数据并且显示
private:
    QBluetoothDeviceDiscoveryAgent *discoveryAgent;//对周围蓝牙进行搜寻
    QBluetoothLocalDevice *localDevice;//对本地设备进行操作
    QBluetoothSocket *socket;//蓝牙配对和数据传输
    QBluetoothServer *server;
    bool openOrNotBluetooth;//蓝牙是否打开
    bool canBeDetect;//是否可以被搜索到
};

#endif // BLUETOOTH_H
