#ifndef CONNECTOR_H
#define CONNECTOR_H

#include <QDebug>
#include <QObject>
#include <QVector>
#include <QBluetoothDeviceInfo>
#include <QBluetoothAddress>

#include "technichub.h"
#include "favoritedevices.h"

class Connector : public QObject
{
    Q_OBJECT
public:
    explicit Connector(FavoriteDevices *f);
    ~Connector();

private:

    QStringList zero;
    QList<QBluetoothDeviceInfo> foundList;
    QVector<Technichub*> connectedDevicesList;
    FavoriteDevices *favDev;

    void getDeviceInfo(int index);

signals:

    void connected();

    void newDeviceAdded(QStringList list);

    void qmlDisconnected(QString address);

    void deviceParamsChanged(QString address, QString name, QStringList list);

    void devicesChanged(QVector<Technichub*> newList);

private slots:

    void getConnectedParam();

    void deviceDisconnected(QString address);

public slots:

    void setFoundList(QList<QBluetoothDeviceInfo> &list);

    void connectDevice(QString address);

    void connectDeviceDirect(QBluetoothDeviceInfo device);

    bool disconnectDevice(QString address);

    void updateConnectedDeviceName(QString address, QString name);

    void deleteFromList(QString address);
};

#endif // CONNECTOR_H
