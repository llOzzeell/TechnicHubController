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

struct Ports{

    static const quint8 A = 0;
    static const quint8 B = 1;
    static const quint8 C = 2;
    static const quint8 D = 3;

    static quint8 getServoPort(int p1, int p2, int p3, int p4){
        if(p1)return A;
        else if(p2) return B;
        else if(p3) return C;
        else if(p4) return D;
        return quint8(4);
    }

    static quint8 getPortByIndex(int index){
        if(index == 0)return A;
        else if(index == 1) return B;
        else if(index == 2) return C;
        else if(index == 3) return D;
        return quint8(4);
    }
};

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
    const int portsCount = 4;

    QString nameFactory="";
    QString name=""; // using in qml
    QString address=""; // using in qml
    quint8 batteryLevel=0; // using in qml

    int lastServoValue;

    bool portsState[4]{false, false, false, false};

signals:

    void lostConnection(QString address, QString name);

    void successConnected(QString address, int type);

    void batteryLevelUpdated(int battery);

    void paramsChanged(QString address, QString name, QStringList list);

    void externalPortsIOchanged(QString address, QList<bool> list);

    void tiltDegreesChanged(QString address, int x, int y);

public slots:

    QList<bool> getPortsState();

    bool isConnected();

    void disconnect();

    void tryConnect(QBluetoothDeviceInfo device);

    int getType();

    int getPortsCount();

    QString getFactoryName();

    void setFactoryName(QString factname);

    void setName(QString _name);

    QString getName();

    QString getAddress();

    QStringList getParamList();

    void runMotor(int speed, int p1, int p2, int p3, int p4);

    void rotateMotor(int angle, int p1, int p2, int p3, int p4);

private slots:

    void writeData(QByteArray &data);

    quint8 calcServoSpeed(int current, int target);

    quint8 calcServoPower(int current, int target);

    void getNewService(const QBluetoothUuid &s);

    void deviceConnected();

    void serviceScanDone();

    void serviceDetailsDiscovered();

    void debugOutHex(const QByteArray &arr, QString description);

    void characteristicUpdated(const QLowEnergyCharacteristic &characteristic, const QByteArray &data);

    void parseHubProperty(const QByteArray &data);

    void parseHubIO(const QByteArray &data);

    void parseSensorValue(const QByteArray &data);

    void setNotification(bool value);

    void setIndication(bool value);

    void disableAll();

    void setBatteryUpdates(bool value);

    void setTiltUpdates();

};

#endif // Technichub_H
