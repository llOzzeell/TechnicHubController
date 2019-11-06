#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QString>
#include <QVariantMap>
#include <QHash>
#include <QList>

#include "technichub.h"

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller();

private:

    QHash<QString,Technichub*> availableDevicesList;

signals:

    void deviceChangedQML();



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
