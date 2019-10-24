#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>

#include "technichub.h"

class Controller : public QObject
{
    Q_OBJECT
public:
    explicit Controller(QObject *parent = nullptr);

private:

    QVector<Technichub*> availableDevicesList;

signals:

public slots:

    void devicesChanged(QVector<Technichub*> newlist);
};

#endif // CONTROLLER_H
