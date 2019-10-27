#include "controller.h"

Controller::Controller(QObject *parent) : QObject(parent), lastServoValue(0)
{

}

void Controller::devicesChanged(QVector<Technichub *> newlist)
{
    qDebug() << "GET TH LIST FROM CONNECTED. list count: " << newlist.count();

    availableDevicesList.clear();

    for(Technichub *t : newlist){
        qDebug() << "---------------------------------------------------------------------------------------------" << t->getAddress();
        qDebug() << "---------------------------------------------------------------------------------------------" << t->getName();
        qDebug() << "---------------------------------------------------------------------------------------------" << t->getType();
        availableDevicesList.insert(t->getAddress(), t);
    }

    emit deviceChangedQML();

     qDebug() << "IN CONTROLLER CLASS count: " << availableDevicesList.count() ;

    for(auto it : availableDevicesList){
        qDebug() << "---------------------------------------------------------------------------------------------" << it->getAddress();
        qDebug() << "---------------------------------------------------------------------------------------------" << it->getName();
        qDebug() << "---------------------------------------------------------------------------------------------" << it->getType();
    }
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

            QByteArray data;
            QDataStream stream(&data, QIODevice::ReadWrite);
            stream.setByteOrder(QDataStream::LittleEndian);

            if(speed == 0) speed = 127;

            stream << quint8(0);
            stream << quint8(0);
            stream << quint8(0x81);
            stream << quint8(4);
            stream << quint8(0x11);
            stream << quint8(0x01);
            stream << qint8(speed);
            stream << quint8(0x64);
            stream << quint8(0x7f);
            stream << quint8(0);
            data[0] = quint8(data.count());

            int portArr[4]{p1,p2,p3,p4};

            for(int i = 0; i < 4; i++){
                if(portArr[i]){
                    data[3] = TechnichubPorts::getPortByIndex(i);
                    availableDevicesList.value(hubAddress)->writeNoResponce(data);
                }
            }
        }
    }
}

quint8 Controller::calcServoSpeed(int current, int target)
{
    if(qAbs(target - current) <= 5) return quint8(10);
        if(qAbs(target - current) <= 10) return quint8(15);
        if(qAbs(target - current) <= 20) return quint8(25);
        if(qAbs(target - current) <= 40) return quint8(45);
        if(qAbs(target - current) >= 50) return quint8(65);
        if(qAbs(target - current) >= 70) return quint8(99);

        return quint8(99);
}

quint8 Controller::calcServoPower(int current, int target)
{
    if(qAbs(target - current) <= 5) return quint8(30);
        if(qAbs(target - current) <= 10) return quint8(35);
        if(qAbs(target - current) <= 20) return quint8(45);
        if(qAbs(target - current) <= 40) return quint8(50);
        if(qAbs(target - current) >= 50) return quint8(60);

        return quint8(59);
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

            if(lastServoValue != angle){

                    QByteArray data;
                    QDataStream stream(&data, QIODevice::ReadWrite);
                    stream.setByteOrder(QDataStream::LittleEndian);

                    stream << quint8(0);
                    stream << quint8(0);
                    stream << quint8(0x81);
                    stream << quint8(TechnichubPorts::getServoPort(p1, p2, p3, p4));
                    stream << quint8(0x11);
                    stream << quint8(0x0d);
                    stream << qint32(angle);

                    stream << calcServoSpeed(lastServoValue, angle);
                    stream << calcServoPower(lastServoValue, angle);

                    stream << quint8(0x7e);
                    stream << quint8(0);

                    data[0] = quint8(data.count());
                    availableDevicesList.value(hubAddress)->writeNoResponce(data);
                    lastServoValue = angle;
            }
        }
    }
}
