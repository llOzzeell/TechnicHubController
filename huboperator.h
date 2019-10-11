#ifndef HUBOPERATOR_H
#define HUBOPERATOR_H

#include <QObject>
#include <QtMath>
#include "technichub.h"

class HubOperator : public QObject
{
    Q_OBJECT
public:
    explicit HubOperator();
    ~HubOperator();

private:

    int _lastValueArray[4]{0};
    bool debugOut;
    TechnicHub *hub;

signals:

private slots:

public slots:

    void setDebugOut(bool value);

    void setHubLink(TechnicHub *link);

    void motor_TurnToDegrees(int port, int angle);

    void hub_SetRGB(int colorNum);

    void motor_RunPermanent(int port, int speed);

    void motor_Stop(int port);

    void motor_RunForTime(int port, int speed, int time);

    void motor_RunForDegrees(int port, int lastAngle, int angle, int maxAngle);

    quint8 servoSpeedCalculate(int curr, int target);

    void motor_SendServoAngle(int port, int angle, int maxAngle);

};

#endif // HUBOPERATOR_H
