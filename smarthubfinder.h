#ifndef SMARTHUBFINDER_H
#define SMARTHUBFINDER_H

#include <QDebug>
#include <QObject>
#include <QList>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>

class SmartHubFinder : public QObject
{
    Q_OBJECT
public:

    SmartHubFinder(int timeoutMS = 5000);

private:

    bool debugOut;
    QBluetoothDeviceDiscoveryAgent * agent;
    QList<QBluetoothDeviceInfo> devicesList;

signals:

    void devicesFound(QList<QBluetoothDeviceInfo> &devicesList);

public slots:

    void setDebugOut(bool value);

    void startScan();

    QList<QString> getDeviceInfoFromQML();

private slots:

    void getInfo(const QBluetoothDeviceInfo &device);

};

#endif // SMARTHUBFINDER_H
