#include "huboperator.h"

HubOperator::HubOperator()
{

}

HubOperator::~HubOperator()
{
    delete hub;
}

void HubOperator::setDebugOut(bool value)
{
    debugOut = value;
}

void HubOperator::setHubLink(TechnicHub *link)
{
    if(debugOut)qDebug() << "Hublink updated : " << link;
    hub = link;
}

void HubOperator::hub_SetRGB(int colorNum)
{
    if(hub){
        QByteArray data;
        data.resize(8);
        data[0] = 0x08;
         data[1] = 0;
          data[2] = 0x81;
           data[3] = 0x32;
            data[4] = 0x11;
             data[5] = 0x51;
              data[6] = 0;
               data[7] = quint8(colorNum);

        hub->writeNoResponce(data);
    }
}

void HubOperator::motor_RunPermanent(int port, int speed)
{
    if(hub){

        QByteArray data;
        QDataStream stream(&data, QIODevice::ReadWrite);
        stream.setByteOrder(QDataStream::LittleEndian);

        if(speed == 0) speed = 127;

        stream << quint8(0);
        stream << quint8(0);
        stream << quint8(0x81);
        stream << quint8(port);
        stream << quint8(0x11);
        stream << quint8(0x01);
        stream << qint8(speed);
        stream << quint8(0x64);
        stream << quint8(0x7f);
        stream << quint8(0);
        data[0] = quint8(data.count());
        hub->writeNoResponce(data);
    }
}

void HubOperator::motor_Stop(int port)
{
    motor_RunPermanent(port, 0);
}

void HubOperator::motor_RunForDegrees(int port, int lastAngle, int angle, int maxAngle)
{
    if(hub){

        QByteArray data;
        QDataStream stream(&data, QIODevice::ReadWrite);
        stream.setByteOrder(QDataStream::LittleEndian);

        int servovalue = maxAngle * angle / 100;

        stream << quint8(0);
        stream << quint8(0);
        stream << quint8(0x81);
        stream << quint8(port);
        stream << quint8(0x11);
        stream << quint8(0x0d);
        stream << quint32(servovalue);
        stream << servoSpeedCalculate(maxAngle * lastAngle / 100, servovalue);
        stream << quint8(50);
        stream << quint8(0x7e);
        stream << quint8(0x00);
        data[0] = quint8(data.count());
        hub->writeNoResponce(data);
    }
}

quint8 HubOperator::servoSpeedCalculate(int curr, int target)
{
   //return quint8(qMax(30, qMin(100, qAbs(curr - target) * 3)));
    if(qAbs(target - curr) <= 5) return quint8(10);
    if(qAbs(target - curr) <= 10) return quint8(15);
    if(qAbs(target - curr) <= 20) return quint8(25);
    if(qAbs(target - curr) <= 40) return quint8(45);
    if(qAbs(target - curr) >= 50) return quint8(65);
    if(qAbs(target - curr) >= 70) return quint8(99);

    return quint8(99);
}

quint8 HubOperator::powerCalculate(int curr, int target)
{
    if(qAbs(target - curr) <= 5) return quint8(30);
    if(qAbs(target - curr) <= 10) return quint8(35);
    if(qAbs(target - curr) <= 20) return quint8(45);
    if(qAbs(target - curr) <= 40) return quint8(50);
    if(qAbs(target - curr) >= 50) return quint8(60);

    return quint8(59);
}

void HubOperator::motor_SendServoAngle(int port, int angle)
{
    if(hub && _lastValueArray[port] != angle){

        QByteArray data;
        QDataStream stream(&data, QIODevice::ReadWrite);
        stream.setByteOrder(QDataStream::LittleEndian);

        stream << quint8(0);
        stream << quint8(0);
        stream << quint8(0x81);
        stream << quint8(port);
        stream << quint8(0x11);
        stream << quint8(0x0d);
        stream << qint32(angle);

        stream << servoSpeedCalculate(_lastValueArray[port], angle);
        stream << powerCalculate(_lastValueArray[port], angle);

        stream << quint8(0x7e);
        stream << quint8(0);

        qDebug() << "delta: " << qAbs(angle - _lastValueArray[port])  << " speed: " << servoSpeedCalculate(_lastValueArray[port], angle) << " power: " << powerCalculate(_lastValueArray[port], angle);

        data[0] = quint8(data.count());
        hub->writeNoResponce(data);
        _lastValueArray[port] = angle;
    }
}

void HubOperator::motor_TurnToDegrees(int port, int angle)
{
    if(hub){

        QByteArray data;
        QDataStream stream(&data, QIODevice::ReadWrite);
        stream.setByteOrder(QDataStream::LittleEndian);

        stream << quint8(0);
        stream << quint8(0);
        stream << quint8(0x81);
        stream << quint8(port);
        stream << quint8(0x11);
        stream << quint8(0x0d);
        stream << quint32(angle);
        stream << quint8(50);
        stream << quint8(50);
        stream << quint8(0x7e);
        stream << quint8(0);
        data[0] = quint8(data.count());
        hub->writeNoResponce(data);
    }
}

void HubOperator::motor_RunForTime(int port, int speed, int time)
{
    if(hub){

        QByteArray data;
        QDataStream stream(&data, QIODevice::ReadWrite);
        stream.setByteOrder(QDataStream::LittleEndian);

        if(speed == 0) speed = 127;

        stream << quint8(0);
        stream << quint8(0);
        stream << quint8(0x81);
        stream << quint8(port);
        stream << quint8(0x11);
        stream << quint8(0x09);
        stream << quint16(time);
        stream << qint8(speed);
        stream << quint8(0x64);
        stream << quint8(0x7f);
        stream << quint8(0x03);
        data[0] = quint8(data.count());
        hub->writeNoResponce(data);
    }
}
