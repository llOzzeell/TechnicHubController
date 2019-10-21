#include "connector.h"

Connector::Connector(FavoriteDevices *f)
{
    favDev = f;
}

Connector::~Connector()
{
     delete favDev;
     for(int i = 0; i < connectedDevicesList.count(); i++){
         delete connectedDevicesList[i];
     }
}

void Connector::setFoundList(QList<QBluetoothDeviceInfo> &list)
{
    if(!foundList.isEmpty())foundList.clear();
    foundList = list;
}

void Connector::connectDevice(int index)
{
    connectedDevicesList.push_back(new Technichub());
    connectedDevicesList[connectedDevicesList.count()-1]->tryConnect(foundList[index]);
    connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::successConnected, [=](){getConnectedParam(); });
    connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::lostConnection, this, &Connector::lostConnection);
    connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::paramsChanged, this, &Connector::deviceParamsChanged);
}

void Connector::connectDeviceDirect(QBluetoothDeviceInfo device)
{
    connectedDevicesList.push_back(new Technichub());
    connectedDevicesList[connectedDevicesList.count()-1]->tryConnect(device);
    connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::successConnected, [=](){getConnectedParam(); });
    connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::lostConnection, this, &Connector::lostConnection);
    connect(connectedDevicesList[connectedDevicesList.count()-1], &Technichub::paramsChanged, this, &Connector::deviceParamsChanged);
}

bool Connector::disconnectDevice(QString address)
{
    int counter = 0;
    for(Technichub *t : connectedDevicesList){
        if(t->getAddress() == address){
            connectedDevicesList[counter]->disconnect();
            connect(connectedDevicesList[counter], &Technichub::lostConnection, [=](){
                delete connectedDevicesList[counter];
                connectedDevicesList.remove(counter);
                return true;
            });
        }
        counter++;
    }
    return false;
}

void Connector::getConnectedParam()
{
    QStringList list;

    list.append(QString::number(connectedDevicesList.count()-1));
    list.append(QString::number(connectedDevicesList[connectedDevicesList.count()-1]->getType()));

    if(favDev->isFavorite(connectedDevicesList[connectedDevicesList.count()-1]->getAddress())){
        connectedDevicesList[connectedDevicesList.count()-1]->setName(favDev->getName(connectedDevicesList[connectedDevicesList.count()-1]->getAddress()));
    }

    list.append(connectedDevicesList[connectedDevicesList.count()-1]->getName());
    list.append(connectedDevicesList[connectedDevicesList.count()-1]->getAddress());

    emit connected();
    emit newDeviceAdded(list);
}
