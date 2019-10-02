#include "technichub.h"

TechnicHub::TechnicHub(): debugOut(false)
{

}

TechnicHub::~TechnicHub()
{
    qDebug() << "TH dtor";
    controller->disconnectFromDevice();
    delete controller;
    delete service1623;
}

void TechnicHub::setDebugOut(bool value)
{
    debugOut = value;
}

void TechnicHub::tryConnect(const QBluetoothDeviceInfo device)
{

    controller = new QLowEnergyController(device);
    connect(controller, &QLowEnergyController::connected, this, &TechnicHub::deviceConnected);
    connect(controller, &QLowEnergyController::serviceDiscovered, this, &TechnicHub::getNewService);
    connect(controller, &QLowEnergyController::discoveryFinished, this, &TechnicHub::serviceScanDone);

    controller->connectToDevice();
}

void TechnicHub::writeData(QByteArray &data)
{
    QString str;
    for(int i = 0; i < data.count(); i++) str +=  " " + QString::number(data[i],16);
    qDebug() << str;

    if(service1623)service1623->writeCharacteristic(chars1624,data,QLowEnergyService::WriteWithoutResponse);
    else if(debugOut)qDebug() << "service1623 == nullptr: "<< service1623;
}

void TechnicHub::getNewService(const QBluetoothUuid &s)
{
    if(debugOut)qDebug() << s.toString();

    if (service1623) {
        delete service1623;
        service1623 = 0;
    }

    if(s.toString().contains("1623")) service1623 = controller->createServiceObject(s);
    if (!service1623) {
        if(debugOut)qDebug() << "Cannot create service for uuid";
        return;
    }
    else if(debugOut)qDebug() << "Service created.";
}

void TechnicHub::deviceConnected()
{
    emit succConnected();
    if(debugOut)qDebug() << "Device connected.";
    if(debugOut)qDebug() << "Start discover services.";
    controller->discoverServices();
}

void TechnicHub::serviceScanDone()
{
    if(debugOut)qDebug() << "Service scan done.";
    if (service1623->state() == QLowEnergyService::DiscoveryRequired) {
        if(debugOut)qDebug() << "Service state: QLowEnergyService::DiscoveryRequired";
        connect(service1623, &QLowEnergyService::stateChanged, this, &TechnicHub::serviceDetailsDiscovered);
        service1623->discoverDetails();
        return;
    }
}

void TechnicHub::serviceDetailsDiscovered()
{
    if(debugOut)qDebug() << service1623->state();
    const QList<QLowEnergyCharacteristic> chars = service1623->characteristics();
    if(debugOut)qDebug() << "Chars count: " << chars.count();
    foreach (const QLowEnergyCharacteristic &ch, chars) {

        if(ch.uuid().toString().contains("1624")) {
            chars1624 = ch;
            if(debugOut)qDebug() << "Chars 1624 found.";
        }
    }
}
