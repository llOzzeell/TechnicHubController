#ifndef PROFILES_H
#define PROFILES_H

#include <QObject>
#include <QDebug>
#include <QFile>
#include <QStandardPaths>
#include <QDataStream>
#include <QVector>
#include <QList>
#include <QGuiApplication>

#include "androidext.h"

struct Control
{
    Control(){ type = 0; width = 0; x = 0; y = 0; invert = false; port1 = "A"; port2 = "A"; servoAngle = 0; maxSpeed = 0;}

    quint8 type;
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

class Profile{
public:
    Profile(QString name = "New profile"): profName(name){}

    QString getName(){return profName;}
    void setName(QString name){profName = name;}

    void clearProfile(){controls.clear();}
    void addControl(Control &con){controls.push_back(con);}

private:
    QString profName;
    QVector<Control> controls;

    friend QDataStream& operator<<(QDataStream &out, Profile &p);
    friend QDataStream& operator>>(QDataStream &in, Profile &p);
};

class Profiles : public QObject
{
    Q_OBJECT
public:
    explicit Profiles(QObject *parent = nullptr);

private:

    QFile file;
    const QString pathToFile = "/profiles.dat";
    QVector<Profile> profiles;

    void getProfilesNamesAndSendToQML();

public slots:

    void loadFromFile();
    void saveToFile();

    void addProfile(QString name);
    bool deleteProfile(int index);

    void saveProfile();

signals:
    void profilesLoaded(QList<QString> list);
};

#endif // PROFILES_H
