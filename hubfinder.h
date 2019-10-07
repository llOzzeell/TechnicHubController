#ifndef SMARTHUBFINDER_H
#define SMARTHUBFINDER_H

#include <QDebug>
#include <QObject>
#include <QList>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>

class HubFinder : public QObject
{
    Q_OBJECT
public:

    HubFinder(int timeoutMS = 10000);
    ~HubFinder();

private:

    int scanTimeOut;
    bool debugOut;
    bool isRunning;
    QBluetoothDeviceDiscoveryAgent * agent;
    QList<QBluetoothDeviceInfo> devicesList;

signals:

    void devicesFound(QList<QBluetoothDeviceInfo> &devicesList);
    void scanFinished();

public slots:

    void setDebugOut(bool value);

    void startScan();

    QList<QString> getDeviceInfoFromQML();

    bool scanIsRunning();

private slots:

    void getInfo(const QBluetoothDeviceInfo &device);

};

#endif // SMARTHUBFINDER_H
