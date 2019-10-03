#ifndef TECHNICHUB_H
#define TECHNICHUB_H

#include <QObject>
#include <QDebug>
#include <QList>
#include <QBluetoothDeviceInfo>
#include <QLowEnergyController>
#include <QBluetoothUuid>
#include <QLowEnergyService>

class TechnicHub : public QObject
{
    Q_OBJECT
public:
    TechnicHub();
    ~TechnicHub();

private:

    bool debugOut;
    QLowEnergyController *controller = nullptr;
    QLowEnergyService *service1623 = nullptr;
    QLowEnergyCharacteristic chars1624;

signals:

    void succConnected();

public slots:

    void setDebugOut(bool value);
    void tryConnect(const QBluetoothDeviceInfo device);

    void writeNoResponce(QByteArray &data);
    void writeResponce(QByteArray &data);

private slots:

    void getNewService(const QBluetoothUuid &s);

    void deviceConnected();

    void serviceScanDone();

    void serviceDetailsDiscovered();

    void getCharsValue(const QLowEnergyCharacteristic &characteristic, const QByteArray &newValue);

    void debugOutHex(const QByteArray &arr, QString description);
};

#endif // TECHNICHUB_H
