#include "controller.h"

Controller::Controller(QObject *parent) : QObject(parent)
{

}

void Controller::devicesChanged(QVector<Technichub *> newlist)
{
    availableDevicesList.clear();

    for(Technichub *t : newlist){
        availableDevicesList.insert(t->getAddress(), t);
    }

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

void Controller::runMotor(int speed, QString hubAddress, int p1, int p2, int p3, int p4)
{
    if(availableDevicesList.contains(hubAddress)){
        if(availableDevicesList.value(hubAddress)->getType() == 0){
            availableDevicesList.value(hubAddress)->runMotor(speed, p1, p2, p3, p4);
        }
    }
}



bool Controller::isNotEmpty()
{
    return availableDevicesList.count() > 0;
}

bool Controller::isAddressValid(QString address)
{
    if(availableDevicesList.contains(address))return true;
    else return false;
}

void Controller::rotateMotor(int angle, QString hubAddress, int p1, int p2, int p3, int p4)
{
    if(availableDevicesList.contains(hubAddress)){
        if(availableDevicesList.value(hubAddress)->getType() == 0){
            availableDevicesList.value(hubAddress)->rotateMotor(angle, p1, p2, p3, p4);
        }
    }
}
