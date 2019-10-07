#include "hubconnector.h"

Hubconnector::Hubconnector(HubFinder *f)
{
    finder = f;
    connect(finder, &HubFinder::devicesFound, this, &Hubconnector::setDeviceList);
}

Hubconnector::~Hubconnector()
{
    if(hub)delete hub;
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
    hubLinkUpdate(hub);
    hub->setDebugOut(debugOut);
    hub->tryConnect(devicesList[index]);
    connect(hub, &TechnicHub::succConnected, this, &Hubconnector::deviceConnectedQML);
}

void Hubconnector::disconnectFromDevice()
{
    delete hub;
}

