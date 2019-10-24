#include "controller.h"

Controller::Controller(QObject *parent) : QObject(parent)
{

}

void Controller::devicesChanged(QVector<Technichub *> newlist)
{
    availableDevicesList.clear();
    availableDevicesList = newlist;

    qDebug() << "------------------------------------------------------------------------------------------------------";
    qDebug() << "COUNT: " << availableDevicesList.count();
}
