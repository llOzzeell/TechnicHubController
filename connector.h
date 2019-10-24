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

    void lostConnection(QString address, QString name, int hubType);

    void deviceParamsChanged(QString address, QStringList list);

    void addDevicePortsPull(QString name, int portsCount);

    void deleteDevicePortsPull(QString name, int portsCount);

private slots:

    void getConnectedParam();

    void portPullLostDeviceInforming(QString address, QString name, int portsCount);

public slots:

    void setFoundList(QList<QBluetoothDeviceInfo> &list);

    void connectDevice(QString address);

    void connectDeviceDirect(QBluetoothDeviceInfo device);

    bool disconnectDevice(QString address);
};

#endif // CONNECTOR_H
