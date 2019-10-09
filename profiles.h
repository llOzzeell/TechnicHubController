#ifndef PROFILES_H
#define PROFILES_H

#include <QObject>
#include <QDebug>
#include <QFile>
#include <QDataStream>
#include <QVector>
#include <QGuiApplication>

struct Control
{
    Control(){ type = 0;
                name = "";
                width = 0;
                x = 0;
                y = 0;
                invert = false;
                port1 = "A";
                port2 = "A";
                servoAngle = 0;
                maxSpeed = 0;}

    quint8 type;
    QString name;
    quint8 width;
    quint8 x;
    quint8 y;
    bool invert;
    QString port1;
    QString port2;
    quint8 servoAngle;
    quint8 maxSpeed;

    friend QDataStream& operator<<(QDataStream &out, Control &p);
    friend QDataStream& operator>>(QDataStream &in, Control &p);

};

class Profiles : public QObject
{
    Q_OBJECT
public:
    explicit Profiles(QObject *parent = nullptr);

private:

    QFile file;
    const QString pathToFile = "/profiles.dat";
    QVector<QVector<Control>> profiles;

public slots:

    void loadFromFile();
    void saveToFile();

    void addProfile();
    bool deleteProfile(int index);

};

#endif // PROFILES_H
