#ifndef FINDER_H
#define FINDER_H

#include <QDebug>
#include <QObject>
#include <QList>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>

#include "connector.h"
#include "favoritedevices.h"

class Finder : public QObject
{
    Q_OBJECT

public:
    explicit Finder(Connector *c, FavoriteDevices *f);
    ~Finder();

private:

    QBluetoothDeviceInfo zero;
    QBluetoothDeviceDiscoveryAgent * agent;
    QList<QBluetoothDeviceInfo> devicesList;
    Connector *connector;
    FavoriteDevices *favDev;

signals:

    void devicesListUpdated(QList<QBluetoothDeviceInfo> &list);
    void deviceFound(QList<QString> list);
    void scanFinished();

private slots:

    void foundDevice(const QBluetoothDeviceInfo &device);

public slots:

    void start();
    void stop();
    bool isScanning();

};

#endif // FINDER_H
