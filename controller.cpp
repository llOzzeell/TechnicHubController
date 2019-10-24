#include "controller.h"

Controller::Controller(QObject *parent) : QObject(parent)
{

}

void Controller::devicesChanged(QVector<Technichub *> newlist)
{
    availableDevicesList.clear();
    availableDevicesList = newlist;
    emit deviceChangedQML();
}

int Controller::getDevicesCount()
{
    return availableDevicesList.count();
}

QVariantMap Controller::getDevicesListQML()
{

    QVariantMap map;
    for(Technichub *t: availableDevicesList){
        map.insert("name", t->getName());
        map.insert("address", t->getAddress());
    }
    return map;
}
