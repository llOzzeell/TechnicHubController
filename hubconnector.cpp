#include "hubconnector.h"

Hubconnector::Hubconnector(SmartHubFinder *f)
{
    finder = f;
    connect(finder, &SmartHubFinder::devicesFound, this, &Hubconnector::setDeviceList);
}

void Hubconnector::setRGBColor(int color)
{
    if(hub){
        QByteArray data;
        data.resize(8);
        //[8]{0x08,0,0x81,0x32,0x11,0x51,0,0}
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

