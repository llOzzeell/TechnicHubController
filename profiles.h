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
    quint8 type;
    quint16 width;
    qint16 x;
    qint16 y;
    bool invert;
    quint8 port1;
    quint8 port2;
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
    Control& getControl(int index){ return controls[index]; }
    int getCount(){return controls.count(); }

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

    Profiles(QObject *parent = nullptr);

private:

    QFile file;
    const QString pathToFile = "/profiles.pf1";
    QVector<Profile> profiles;
    QList<QString>names;

    void getProfilesNamesAndSendToQML();

public slots:

    void loadFromFile();
    void saveToFile();

    void addProfile(QString name);
    bool deleteProfile(int index);

    QList<QString> getProfilesNames();
    void updateProfileName(int profileIndex, QString name);
    void clearControlInProfile(int profileIndex);
    void addProfileControls(int profileIndex, int type, int width, int x, int y, bool inverted, int port1, int port2, int servo, int maxspeed);
    int getControlsCounts(int profileIndex);
    QList<QString> getProfileControls(int profileIndex, int controlIndex);

};

#endif // PROFILES_H
