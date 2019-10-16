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
    if(isRunning){ agent->stop(); }
    isRunning = true;
    devicesList.clear();
    agent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
}

void HubFinder::stopScan()
{
    isRunning = false;
    agent->stop();
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
        for(QBluetoothDeviceInfo d : devicesList){
            if(device.address() == d.address())return;
        }
        devicesList.append(device);
        emit devicesFound(devicesList);
    }
}

