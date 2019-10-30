#include "technichub.h"

Technichub::Technichub()
{

}

Technichub::~Technichub()
{
    delete controller;
    delete service1623;
}

void Technichub::disconnect()
{
    controller->disconnectFromDevice();
}

void Technichub::tryConnect(QBluetoothDeviceInfo device)
{

    controller = new QLowEnergyController(device);
    connect(controller, &QLowEnergyController::connected, this, &Technichub::deviceConnected);
    connect(controller, &QLowEnergyController::disconnected, [=](){emit lostConnection(address, name);});
    connect(controller, &QLowEnergyController::serviceDiscovered, this, &Technichub::getNewService);
    connect(controller, &QLowEnergyController::discoveryFinished, this, &Technichub::serviceScanDone);

    name = device.name();
    address = device.address().toString();
    controller->connectToDevice();
}

void Technichub::getNewService(const QBluetoothUuid &s)
{
    qDebug() << s.toString();

    if (service1623) {
        delete service1623;
        service1623 = nullptr;
    }

    if(s.toString().contains("1623")) service1623 = controller->createServiceObject(s);
    if (!service1623) {
        qDebug() << "Cannot create service for uuid";
        return;
    }
    else qDebug() << "Service created.";
}

void Technichub::deviceConnected()
{
    if(QGuiApplication::platformName() != "windows"){ qDebug() << "NON WINDOWS EMITTING"; emit successConnected(address, hubType); }
    qDebug() << "Device connected.";
    qDebug() << "Start discover services.";
    controller->discoverServices();
}

void Technichub::serviceScanDone()
{
    qDebug() << "Service scan done.";
    if (service1623->state() == QLowEnergyService::DiscoveryRequired) {
        qDebug() << "Service state: QLowEnergyService::DiscoveryRequired";
        connect(service1623, &QLowEnergyService::stateChanged, this, &Technichub::serviceDetailsDiscovered);
        //connect(service1623, &QLowEnergyService::characteristicRead, this, &Technichub::getCharsValue);
        service1623->discoverDetails();
        return;
    }
}

void Technichub::serviceDetailsDiscovered()
{
    if(QGuiApplication::platformName() == "windows"){qDebug() << "WINDOWS EMITTING"; emit successConnected(address, hubType); }
    qDebug() << service1623->state();
    const QList<QLowEnergyCharacteristic> chars = service1623->characteristics();
    qDebug() << "Chars count: " << chars.count();
    foreach (const QLowEnergyCharacteristic &ch, chars) {

        if(ch.uuid().toString().contains("1624")) {
            chars1624 = ch;
            qDebug() << "Chars 1624 found.";
            setNotification(true);
            connect(service1623, &QLowEnergyService::characteristicChanged, this, &Technichub::characteristicUpdated);
            //setRSSIUpdates(true);
            setBatteryUpdates(true);
        }
    }
}

void Technichub::debugOutHex(const QByteArray &arr, QString description)
{
    QString str = description + " ";
    for(int i = 0; i < arr.count(); i++) str += "|" + QString::number(arr[i], 16);
    str += " len=";
    str += QString::number(arr.count());
    qDebug() << str;
}

void Technichub::characteristicUpdated(const QLowEnergyCharacteristic &characteristic, const QByteArray &newValue)
{
    Q_UNUSED(characteristic)
    //debugOutHex(newValue, "CHARS CHANGED get:");
    parseCharsUpdates(newValue);
}

void Technichub::parseCharsUpdates(const QByteArray &newValue)
{
    static int oldBattery = 0;

    if(newValue[2] == 1){ // hub property
        if(newValue[3] == 6 && newValue[4] == 6)batteryLevel = newValue[5]; // battery % value updated
    }

    if(oldBattery != batteryLevel){

        emit paramsChanged(address, name, getParamList());
    }

    oldBattery = batteryLevel;
}

/////////////////////////////////////////////////

void Technichub::writeNoResponce(QByteArray &data)
{
    debugOutHex(data, "set:");

    if(service1623)service1623->writeCharacteristic(chars1624,data,QLowEnergyService::WriteWithoutResponse);
    else qDebug() << "service1623 == nullptr: "<< service1623;
}

void Technichub::writeResponce(QByteArray &data)
{
    debugOutHex(data, "set:");

    if(service1623)service1623->writeCharacteristic(chars1624,data,QLowEnergyService::WriteWithResponse);
    else qDebug() << "service1623 == nullptr: "<< service1623;
}

/////////////////////////////////////////////////////

void Technichub::setNotification(bool value)
{
    QLowEnergyDescriptor d = chars1624.descriptor(QBluetoothUuid::ClientCharacteristicConfiguration);
    if(!chars1624.isValid()){
        return;
    }
    if(chars1624.properties() & QLowEnergyCharacteristic::Notify){ // enable notification
        service1623->writeDescriptor(d, value ? QByteArray::fromHex("0100") : QByteArray::fromHex("0000"));
    }

}

void Technichub::setIndication(bool value)
{
    QLowEnergyDescriptor d = chars1624.descriptor(QBluetoothUuid::ClientCharacteristicConfiguration);
    if(!chars1624.isValid()){
        return;
    }
    if(chars1624.properties() & QLowEnergyCharacteristic::Indicate){ // enable indication
        service1623->writeDescriptor(d, value ? QByteArray::fromHex("0200") : QByteArray::fromHex("0000"));
    }
}

void Technichub::disableAll()
{
    QLowEnergyDescriptor d = chars1624.descriptor(QBluetoothUuid::ClientCharacteristicConfiguration);
    if(!chars1624.isValid()){
        return;
    }
    if(chars1624.properties() & QLowEnergyCharacteristic::Indicate){ // enable indication
        service1623->writeDescriptor(d, QByteArray::fromHex("0000"));
    }
}

////////////////////////////////////////////////////

void Technichub::setBatteryUpdates(bool value)
{
    QByteArray data;
    QDataStream stream(&data, QIODevice::ReadWrite);
    stream.setByteOrder(QDataStream::LittleEndian);

    stream << quint8(0); // common header \ message length
    stream << quint8(0);
    stream << quint8(1);
    stream << quint8(6);

    quint8 trigger = value ? 2 : 3;

    stream << trigger;
    data[0] = quint8(data.count());
    writeNoResponce(data);
}

void Technichub::setRSSIUpdates(bool value)
{
    QByteArray data;
    QDataStream stream(&data, QIODevice::ReadWrite);
    stream.setByteOrder(QDataStream::LittleEndian);

    stream << quint8(0); // common header \ message length
    stream << quint8(0);
    stream << quint8(1);
    stream << quint8(5);

    quint8 trigger = value ? 2 : 3;

    stream << trigger;
    data[0] = quint8(data.count());
    writeNoResponce(data);
}

///////////////////////////////////

int Technichub::getType()
{
    return hubType;
}

int Technichub::getPortsCount()
{
    return portsCount;
}

QString Technichub::getFactoryName()
{
    return nameFactory;
}

void Technichub::setFactoryName(QString factname)
{
    nameFactory = factname;
}

void Technichub::setName(QString _name)
{
    name = _name;
}

QString Technichub::getName()
{
    return name;
}

QString Technichub::getAddress()
{
    return address;
}

QStringList Technichub::getParamList()
{
    QStringList list;
    list.append(QString::number(batteryLevel));
    return list;
}

bool Technichub::isConnected()
{
    if(controller->state() != QLowEnergyController::ConnectedState) return false;
    else return true;
}
