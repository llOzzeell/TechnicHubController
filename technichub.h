#ifndef Technichub_H
#define Technichub_H

#include <QObject>
#include <QString>
#include <QBluetoothDeviceInfo>
#include <QLowEnergyController>
#include <QBluetoothUuid>
#include <QLowEnergyService>
#include <QGuiApplication>
#include <QDataStream>
#include <QtMath>

class Technichub : public QObject
{
    Q_OBJECT
public:
    explicit Technichub();
    ~Technichub();

private:

    QLowEnergyController *controller = nullptr;
    QLowEnergyService *service1623 = nullptr;
    QLowEnergyCharacteristic chars1624;

    const int hubType = 0x0; // hub type, using in qml for drawing right icon

    QString name=""; // using in qml
    QString address=""; // using in qml
    qint8 rssiLevel = 0; // using in qml
    quint8 batteryLevel=0; // using in qml

signals:

    void lostConnection(QString address);

    void successConnected();

    void batteryLevelUpdated(int battery);

    void rssiLevelUpdated(int rssi);

    void paramsChanged(QString address, QStringList list);

public slots:

    void disconnect();

    void tryConnect(QBluetoothDeviceInfo device);

    void writeNoResponce(QByteArray &data);

    void writeResponce(QByteArray &data);

    int getType();

    void setName(QString _name);

    QString getName();

    QString getAddress();

    QStringList getParamList();

private slots:

    void getNewService(const QBluetoothUuid &s);

    void deviceConnected();

    void serviceScanDone();

    void serviceDetailsDiscovered();

    void debugOutHex(const QByteArray &arr, QString description);

    void characteristicUpdated(const QLowEnergyCharacteristic &characteristic, const QByteArray &newValue);

    void parseCharsUpdates(const QByteArray &newValue);

    void setNotification(bool value);

    void setIndication(bool value);

    void disableAll();

    void setBatteryUpdates(bool value);

    void setRSSIUpdates(bool value);

};

#endif // Technichub_H
