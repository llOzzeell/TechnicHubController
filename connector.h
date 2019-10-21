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

    void lostConnection(QString address);

    void deviceParamsChanged(QString address, QStringList list);

private slots:

    void getConnectedParam();

public slots:

    void setFoundList(QList<QBluetoothDeviceInfo> &list);

    void connectDevice(QString address);

    void connectDeviceDirect(QBluetoothDeviceInfo device);

    bool disconnectDevice(QString address);
};

#endif // CONNECTOR_H
