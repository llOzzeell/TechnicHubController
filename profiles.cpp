#include "profiles.h"

QDataStream& operator<<(QDataStream &out, Control &p)
{
    out << p.type << p.width << p.x << p.y << p.invert << p.port1 << p.port2 << p.servoAngle << p.maxSpeed;
    return out;
}

QDataStream& operator>>(QDataStream &in, Control &p)
{
    in >> p.type >> p.width >> p.x >> p.y >> p.invert >> p.port1 >> p.port2 >> p.servoAngle >> p.maxSpeed;
    return in;
}

QDataStream& operator<<(QDataStream &out, Profile &p)
{
    out << p.profName << p.controls.count();
    for(auto con : p.controls){
        out << con;
    }
    return out;
}

QDataStream& operator>>(QDataStream &in, Profile &p)
{
    in >> p.profName;
    int controlsCount; in >> controlsCount;
    for(int i = 0; i < controlsCount; i++){
        Control con; in >> con;
        p.controls.push_back(con);
    }
    return in;
}


Profiles::Profiles(QObject *parent) : QObject(parent)
{
    loadFromFile();
}


void Profiles::loadFromFile()
{
    auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QFile file(path + pathToFile);

    //QFile file(qApp->applicationDirPath() + pathToFile);

    if(file.exists())
    {
        file.open(QIODevice::ReadOnly);
        QDataStream in(&file);

        int count; in >> count;

        for(int i = 0; i < count; i++){
            Profile p;
            in >> p;
            profiles.push_back(p);
        }
    }
    file.close();

    for(auto profile : profiles){
        names.append(profile.getName());
    }
}

void Profiles::saveToFile()
{
    auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    QFile file(path + pathToFile);

    //QFile file(qApp->applicationDirPath() + pathToFile);

    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);

    out << profiles.count();

    for ( auto item : profiles )
    {
        out << item;
    }
    file.close();
}

void Profiles::addProfile(QString name)
{
    Profile p;
    p.setName(name);
    profiles.push_back(p);
    saveToFile();
}

bool Profiles::deleteProfile(int index)
{
    if(index >= 0 && index < profiles.count()){
        profiles.removeAt(index);
        saveToFile();
        return true;
    }
    else return false;
}

QList<QString> Profiles::getProfilesNames()
{
    return names;
}

void Profiles::updateProfileName(int profileIndex, QString name)
{
    profiles[profileIndex].setName(name);
    saveToFile();
}

void Profiles::clearControlInProfile(int profileIndex)
{
    profiles[profileIndex].clearProfile();
}

void Profiles::addProfileControls(int profileIndex, int type, int width, int x, int y, bool inverted, int port1, int port2, int servo, int maxspeed)
{
    Control con{quint8(type), quint16(width), qint16(x), qint16(y), inverted, quint8(port1), quint8(port2), quint8(servo), quint8(maxspeed)};
    profiles[profileIndex].addControl(con);
}

int Profiles::getControlsCounts(int profileIndex)
{
    return profiles[profileIndex].getCount();
}

QList<QString> Profiles::getProfileControls(int profileIndex, int controlIndex)
{
    QList<QString> list;
    Control c = profiles[profileIndex].getControl(controlIndex);

    list.append(QString::number(c.type));
    list.append(QString::number(c.width));
    list.append(QString::number(c.x));
    list.append(QString::number(c.y));
    list.append(QString::number(c.invert));
    list.append(QString::number(c.port1));
    list.append(QString::number(c.port2));
    list.append(QString::number(c.servoAngle));
    list.append(QString::number(c.maxSpeed));

    return list;
}
