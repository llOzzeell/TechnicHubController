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
    bool scanForFavorite;
    Connector *connector;
    FavoriteDevices *favDev;
    int favoriteDevicesCount;

signals:

    void devicesListUpdated(QList<QBluetoothDeviceInfo> &list);
    void deviceFound(QList<QString> list);
    void scanFinished();

private slots:

    void gotNewDevice(const QBluetoothDeviceInfo &device);

public slots:

    void startScanFavorite();
    void start();
    void stop();
    bool isScanning();
    bool isFavoriteScanning();

};

#endif // FINDER_H
