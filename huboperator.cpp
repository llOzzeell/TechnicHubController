#include "huboperator.h"

HubOperator::HubOperator()
{

}

HubOperator::~HubOperator()
{
    delete hub;
}

quint8 HubOperator::getPortAddress(QString port)
{
    if(port == "A") return ports.portA;
    else if(port == "B") return ports.portB;
    else if(port == "C") return ports.portC;
    else if(port == "D") return ports.portD;
    else return 0;
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

void HubOperator::motor_TurnToDegrees(QString port, int angle)
{
    if(hub){

        QByteArray data;
        QDataStream stream(&data, QIODevice::ReadWrite);
        stream.setByteOrder(QDataStream::LittleEndian);

        stream << quint8(0);
        stream << quint8(0);
        stream << quint8(0x81);
        stream << getPortAddress(port);
        stream << quint8(0x11);
        stream << quint8(0x0d);
        stream << quint32(angle);
        stream << quint8(50);
        stream << quint8(50);
        stream << quint8(0x7e);
        stream << quint8(0);
        data[0] = data.count();
        hub->writeNoResponce(data);
    }
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

void HubOperator::motor_RunPermanent(QString port, int speed)
{
    if(hub){

        QByteArray data;
        QDataStream stream(&data, QIODevice::ReadWrite);
        stream.setByteOrder(QDataStream::LittleEndian);

        if(speed == 0) speed = 127;

        stream << quint8(0);
        stream << quint8(0);
        stream << quint8(0x81);
        stream << getPortAddress(port);
        stream << quint8(0x11);
        stream << quint8(0x01);
        stream << qint8(speed);
        stream << quint8(0x64);
        stream << quint8(0x7f);
        stream << quint8(0);
        data[0] = data.count();
        hub->writeNoResponce(data);
    }
}

void HubOperator::motor_Stop(QString port)
{
    motor_RunPermanent(port, 0);
}

void HubOperator::motor_RunForTime(QString port, int speed, int time)
{
    if(hub){

        QByteArray data;
        QDataStream stream(&data, QIODevice::ReadWrite);
        stream.setByteOrder(QDataStream::LittleEndian);

        if(speed == 0) speed = 127;

        stream << quint8(0);
        stream << quint8(0);
        stream << quint8(0x81);
        stream << getPortAddress(port);
        stream << quint8(0x11);
        stream << quint8(0x09);
        stream << quint16(time);
        stream << qint8(speed);
        stream << quint8(0x64);
        stream << quint8(0x7f);
        stream << quint8(0x03);
        data[0] = data.count();
        hub->writeNoResponce(data);
    }
}

void HubOperator::motor_RunForDegrees(QString port, int lastAngle, int angle, int maxServoAngle)
{
    if(hub){

        QByteArray data;
        QDataStream stream(&data, QIODevice::ReadWrite);
        stream.setByteOrder(QDataStream::LittleEndian);

        int servovalue = maxServoAngle * angle / 100;

        stream << quint8(0);
        stream << quint8(0);
        stream << quint8(0x81);
        stream << getPortAddress(port);
        stream << quint8(0x11);
        stream << quint8(0x0d);
        stream << quint32(servovalue);
        stream << servoSpeedCalculate(maxServoAngle * lastAngle / 100, servovalue);
        stream << quint8(50);
        stream << quint8(0x7e);
        stream << quint8(0x00);
        data[0] = quint8(data.count());
        hub->writeNoResponce(data);
    }
}

quint8 HubOperator::servoSpeedCalculate(int curr, int target)
{
    return quint8(qMax(40, qMin(100, qAbs(curr - target) * 3)));
}

