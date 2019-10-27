#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QHash>
#include <QList>

#include "technichub.h"

struct TechnichubPorts{

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

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = nullptr);

private:

    QHash<QString,Technichub*> availableDevicesList;

    int lastServoValue;

signals:

    void deviceChangedQML();

private slots:

    quint8 calcServoSpeed(int current, int target);

    quint8 calcServoPower(int current, int target);

public slots:

    bool isNotEmpty();

    bool isAddressValid(QString address);

    void devicesChanged(QVector<Technichub*> newlist);

    int getDevicesCount();

    QVariantMap getDevicesListQML();

    void runMotor(int speed, QString hubAddress, int p1, int p2, int p3, int p4);

    void rotateMotor(int angle, QString hubAddress, int p1, int p2, int p3, int p4);
};

#endif // CONTROLLER_H
