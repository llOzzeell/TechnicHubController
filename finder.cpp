#include "finder.h"

Finder::Finder(Connector *c, FavoriteDevices *f)
{
    connector = c;
    favDev = f;
}

Finder::~Finder(){
    if(agent->isActive()) agent->stop();
    delete agent;
    delete connector;
}

void Finder::foundDevice(const QBluetoothDeviceInfo &device)
{
    if(device.name() != "Technic Hub") return;

    for(QBluetoothDeviceInfo d : devicesList){
    if(device.address() == d.address())return;
    }

    devicesList.append(device);

    QList<QString> textDeviceList;

    foreach (auto item, devicesList) {

        QString name = "";
        if(favDev->isFavorite(device.address().toString())){
            name = favDev->getName(device.address().toString());
        }
        else name = item.name();

        textDeviceList.append(name + " (" + item.address().toString() + ")");
    }

    emit deviceFound(textDeviceList);
    emit devicesListUpdated(devicesList);
}

void Finder::start()
{
    agent = new QBluetoothDeviceDiscoveryAgent();
    agent->setLowEnergyDiscoveryTimeout(0);
    agent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
    connect(agent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &Finder::foundDevice);
    connect(agent, &QBluetoothDeviceDiscoveryAgent::finished, [=](){ emit scanFinished();});
}

void Finder::stop()
{
    devicesList.clear();
    agent->stop();
    delete agent;
}

bool Finder::isScanning()
{
    if(agent != nullptr) return agent->isActive();
    else return false;
}

