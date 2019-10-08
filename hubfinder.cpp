#include "hubfinder.h"

HubFinder::HubFinder(int timeoutMS):scanTimeOut(timeoutMS),isRunning(false)
{
    agent = new QBluetoothDeviceDiscoveryAgent(this);
    agent->setLowEnergyDiscoveryTimeout(timeoutMS);
    connect(agent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &HubFinder::getInfo);
    connect(agent, &QBluetoothDeviceDiscoveryAgent::finished, [=](){ emit scanFinished(); isRunning = false; if(debugOut)qDebug() << "Scan finished.";});
}

HubFinder::~HubFinder(){
    if(agent)delete agent;
}

void HubFinder::setDebugOut(bool value)
{
    debugOut = value;
}

void HubFinder::startScan()
{
    isRunning = true;
    devicesList.clear();
    agent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
}

QList<QString> HubFinder::getDeviceInfoFromQML()
{
    QList<QString> textDeviceList;
    foreach (auto item, devicesList) {
        textDeviceList.append(item.name() + " (" + item.address().toString() + ")");
    }
    return textDeviceList;
}

bool HubFinder::scanIsRunning()
{
    return isRunning;
}

void HubFinder::getInfo(const QBluetoothDeviceInfo &device)
{
    if(device.name() == "Technic Hub"){
        if(debugOut) qDebug() << "Found:" << device.name() << '(' << device.address().toString() << ')';
        devicesList.append(device);
        emit devicesFound(devicesList);
    }
}

