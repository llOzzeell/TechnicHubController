#ifndef HUBOPERATOR_H
#define HUBOPERATOR_H

#include <QObject>
#include <QtMath>
#include "technichub.h"

struct PortsAddress{
    quint8 portA = 0x00;
    quint8 portB = 0x01;
    quint8 portC = 0x02;
    quint8 portD = 0x03;
};

class HubOperator : public QObject
{
    Q_OBJECT
public:
    explicit HubOperator();
    ~HubOperator();

private:

    PortsAddress ports;
    bool debugOut;
    TechnicHub *hub;

signals:

private slots:

    quint8 getPortAddress(QString port);

    qint32 normalizeAngle(int angle);

public slots:

    void setDebugOut(bool value);

    void setHubLink(TechnicHub *link);

    void motor_TurnToDegrees(QString port, int angle);

    void hub_SetRGB(int colorNum);

    void motor_RunPermanent(QString port, int speed);

    void motor_Stop(QString port);

    void motor_RunForTime(QString port, int speed, int time);

    void motor_RunForDegrees(QString port, int lastAngle, int angle, int maxServoAngle);

    quint8 servoSpeedCalculate(int curr, int target);

};

#endif // HUBOPERATOR_H
