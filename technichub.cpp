#include "technichub.h"

Technichub::Technichub():lastServoValue(0)
{

}

Technichub::~Technichub()
{
    delete controller;
    delete service1623;
}

QList<bool> Technichub::getPortsState()
{
    QList<bool> list;
    list.append(portsState[0]);
    list.append(portsState[1]);
    list.append(portsState[2]);
    list.append(portsState[3]);
    return list;
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

void Technichub::characteristicUpdated(const QLowEnergyCharacteristic &characteristic, const QByteArray &data)
{
    Q_UNUSED(characteristic)
    //debugOutHex(data, "CHARS CHANGED get:");
    switch(data[2]){
        case 1: parseHubProperty(data); break;
        case 4: parseHubIO(data); break;
    }
}

void Technichub::parseHubProperty(const QByteArray &data)
{
    if(data[3] == 6 && data[4] == 6){
        batteryLevel = data[5]; // battery % value updated
        emit paramsChanged(address, name, getParamList());
    }
}

void Technichub::parseHubIO(const QByteArray &data)
{
    if((data[3] >= 0) && (data[3] <= 3)){
        portsState[static_cast<int>(data[3])] = static_cast<bool>(data[4]);
        QList<bool> list;
        list.append(portsState[0]);
        list.append(portsState[1]);
        list.append(portsState[2]);
        list.append(portsState[3]);
        emit externalPortsIOchanged(address, list);
    }
}

/////////////////////////////////////////////////

void Technichub::writeData(QByteArray &data)
{
    //debugOutHex(data, "set:");

    if(service1623 == nullptr)return;

    service1623->writeCharacteristic(chars1624,data,QLowEnergyService::WriteWithoutResponse);
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
    stream << quint8(6); // prop type
    stream << quint8(0); //operation

    data[0] = quint8(data.count());

    data[4] = value ? 2 : 3;
    writeData(data);
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

quint8 Technichub::calcServoSpeed(int current, int target)
{
    if(qAbs(target - current) <= 5) return quint8(10);
        if(qAbs(target - current) <= 10) return quint8(15);
        if(qAbs(target - current) <= 20) return quint8(25);
        if(qAbs(target - current) <= 40) return quint8(45);
        if(qAbs(target - current) >= 50) return quint8(65);
        if(qAbs(target - current) >= 70) return quint8(99);

        return quint8(99);
}

quint8 Technichub::calcServoPower(int current, int target)
{
    if(qAbs(target - current) <= 5) return quint8(30);
        if(qAbs(target - current) <= 10) return quint8(35);
        if(qAbs(target - current) <= 20) return quint8(45);
        if(qAbs(target - current) <= 40) return quint8(50);
        if(qAbs(target - current) >= 50) return quint8(60);

        return quint8(59);
}

bool Technichub::isConnected()
{
    if(controller->state() != QLowEnergyController::ConnectedState) return false;
    else return true;
}

void Technichub::runMotor(int speed, int p1, int p2, int p3, int p4)
{
    QByteArray data;
    QDataStream stream(&data, QIODevice::ReadWrite);
    stream.setByteOrder(QDataStream::LittleEndian);

    if(speed == 0) speed = 127;

    stream << quint8(0);
    stream << quint8(0);
    stream << quint8(0x81);
    stream << quint8(4);
    stream << quint8(0x11);
    stream << quint8(0x01);
    stream << qint8(speed);
    stream << quint8(0x64);
    stream << quint8(0x0);
    data[0] = quint8(data.count());

    int portArr[4]{p1,p2,p3,p4};

    for(int i = 0; i < 4; i++){
        if(portArr[i]){
            data[3] = Ports::getPortByIndex(i);
            writeData(data);
        }
    }
}

void Technichub::rotateMotor(int angle, int p1, int p2, int p3, int p4)
{
    if(lastServoValue != angle){

            QByteArray data;
            QDataStream stream(&data, QIODevice::ReadWrite);
            stream.setByteOrder(QDataStream::LittleEndian);

            stream << quint8(0);
            stream << quint8(0);
            stream << quint8(0x81);
            stream << quint8(Ports::getServoPort(p1, p2, p3, p4));
            stream << quint8(0x11);
            stream << quint8(0x0d);
            stream << qint32(angle);

            stream << calcServoSpeed(lastServoValue, angle);
            stream << calcServoPower(lastServoValue, angle);

            stream << quint8(0x7e);
            stream << quint8(0);

            data[0] = quint8(data.count());
            writeData(data);
            lastServoValue = angle;
    }
}



