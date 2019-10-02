#include "smarthubfinder.h"

SmartHubFinder::SmartHubFinder(int timeoutMS)
{
    agent = new QBluetoothDeviceDiscoveryAgent(this);
    agent->setLowEnergyDiscoveryTimeout(timeoutMS);
    connect(agent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &SmartHubFinder::getInfo);
    connect(agent, &QBluetoothDeviceDiscoveryAgent::finished, [=](){ if(debugOut)qDebug() << "Scan finished.";});
}

void SmartHubFinder::setDebugOut(bool value)
{
    debugOut = value;
}

void SmartHubFinder::startScan()
{
    devicesList.clear();
    agent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
}

QList<QString> SmartHubFinder::getDeviceInfoFromQML()
{
    QList<QString> textDeviceList;
    foreach (auto item, devicesList) {
        textDeviceList.append(item.name() + " (" + item.address().toString() + ")");
    }
    return textDeviceList;
}

void SmartHubFinder::getInfo(const QBluetoothDeviceInfo &device)
{
    if(device.name() == "Technic Hub"){
        if(debugOut) qDebug() << "Found:" << device.name() << '(' << device.address().toString() << ')';
        devicesList.append(device);
        emit devicesFound(devicesList);
    }
}

