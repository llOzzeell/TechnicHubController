#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QVariantMap>
#include <QList>

#include "technichub.h"

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = nullptr);

private:

    QVector<Technichub*> availableDevicesList;

signals:

    void deviceChangedQML();

public slots:

    void devicesChanged(QVector<Technichub*> newlist);

    int getDevicesCount();

    QVariantMap getDevicesListQML();
};

#endif // CONTROLLER_H
