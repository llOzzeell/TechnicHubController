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
    getProfilesNamesAndSendToQML();
}

void Profiles::getProfilesNamesAndSendToQML()
{
    QList<QString> li;

    for(auto profile : profiles){
        li.append(profile.getName());
        qDebug() << profile.getName();
    }

    emit profilesLoaded(li);
}

void Profiles::loadFromFile()
{
    auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    qDebug() << path + pathToFile;
    QFile file(path + pathToFile);

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
}

void Profiles::saveToFile()
{
    //AndroidExt::requestAndroidPermissions();

    auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    qDebug() << path + pathToFile;
    QFile file(path + pathToFile);

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
        return true;
    }
    else return false;
}

void Profiles::saveProfile()
{

}
