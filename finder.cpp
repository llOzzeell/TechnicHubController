#include "finder.h"

Finder::Finder(Connector *c, FavoriteDevices *f):scanForFavorite(false),favoriteDevicesCount(-1)
{
    connector = c;
    favDev = f;
    agent = new QBluetoothDeviceDiscoveryAgent(this);
    agent->setLowEnergyDiscoveryTimeout(0);
    connect(agent, &QBluetoothDeviceDiscoveryAgent::deviceDiscovered, this, &Finder::gotNewDevice);
    connect(agent, &QBluetoothDeviceDiscoveryAgent::finished, [=](){ emit scanFinished();});
}

Finder::~Finder(){
    if(agent->isActive()) agent->stop();
    delete agent;
    delete connector;
}

void Finder::gotNewDevice(const QBluetoothDeviceInfo &device)
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

//    if(favoriteDevicesCount <= 0){ stop(); scanForFavorite = false;}

//    if(!scanForFavorite){
//        for(QBluetoothDeviceInfo d : devicesList){
//            if(device.address() == d.address())return;
//        }

//        devicesList.append(device);

//        QList<QString> textDeviceList;

//        foreach (auto item, devicesList) {

//            QString name = "";
//            if(favDev->isFavorite(device.address().toString())){
//                name = favDev->getName(device.address().toString());
//            }
//            else name = item.name();

//            textDeviceList.append(name + " (" + item.address().toString() + ")");
//        }

//        emit deviceFound(textDeviceList);
//        emit devicesListUpdated(devicesList);
//    }
//    else{

//        if(favDev->isFavorite(device.address().toString())){
//            connector->connectDeviceDirect(device);
//            favoriteDevicesCount--;
//        }

//        if(favoriteDevicesCount <= 0){ stop(); scanForFavorite = false;}
//    }
}

void Finder::startScanFavorite()
{
    scanForFavorite = true;
    favoriteDevicesCount = favDev->getCount();
    if(agent->isActive()) agent->stop();
    agent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
}

void Finder::start()
{
    scanForFavorite = false;
    if(agent->isActive()) agent->stop();
    devicesList.clear();
    agent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
}

void Finder::stop()
{
    scanForFavorite = false;
    agent->stop();
}

bool Finder::isScanning()
{
    return agent->isActive();
}

bool Finder::isFavoriteScanning()
{
    return (scanForFavorite && agent->isActive());
}

