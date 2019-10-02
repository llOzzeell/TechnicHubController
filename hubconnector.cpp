#include "hubconnector.h"

Hubconnector::Hubconnector(SmartHubFinder *f)
{
    finder = f;
    connect(finder, &SmartHubFinder::devicesFound, this, &Hubconnector::setDeviceList);
}

Hubconnector::~Hubconnector()
{
    if(hub)delete hub;
}

void Hubconnector::setMotorRun(int angle)
{
    if(hub){
        QByteArray data;
        QDataStream stream(&data, QIODevice::ReadWrite);
        stream.setByteOrder(QDataStream::LittleEndian);

        quint32 a =  (angle + (360 * ((angle - 180) / 360)));

        stream << quint8(0);
        stream << quint8(0);
        stream << quint8(0x81);
        stream << quint8(0x01);
        stream << quint8(0x11);
        stream << quint8(0x0d);
        stream << a;
        stream << quint8(30);
        stream << quint8(0x64);
        stream << quint8(0x7e);
        stream << quint8(0);
        data[0] = data.count();
        hub->writeData(data);
    }
}

void Hubconnector::setRGBColor(int color)
{
    if(hub){
        QByteArray data;
        data.resize(8);
        data[0] = 0x08;
         data[1] = 0;
          data[2] = 0x81;
           data[3] = 0x32;
            data[4] = 0x11;
             data[5] = 0x51;
              data[6] = 0;
               data[7] = quint8(color);

        hub->writeData(data);
    }
}

void Hubconnector::setDebugOut(bool value)
{
    debugOut = value;
}

void Hubconnector::setDeviceList(const QList<QBluetoothDeviceInfo> &dl)
{
    if(!devicesList.isEmpty())devicesList.clear();
    devicesList = dl;

}

void Hubconnector::connectTo(int index)
{
    emit deviceNameNotify(devicesList[index].name());
    hub = new TechnicHub();
    hub->setDebugOut(debugOut);
    hub->tryConnect(devicesList[index]);
    connect(hub, &TechnicHub::succConnected, this, &Hubconnector::deviceConnectedQML);
}

void Hubconnector::disconnectFromDevice()
{
    delete hub;
}

