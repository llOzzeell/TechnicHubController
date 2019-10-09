#include "profiles.h"

// перегрузка операторов структур данных
QDataStream& operator<<(QDataStream &out, Control &p)
{
    out << p.type << p.name << p.width << p.x << p.y << p.invert << p.port1 << p.port2 << p.servoAngle << p.maxSpeed;
    return out;
}
QDataStream& operator>>(QDataStream &in, Control &p)
{
    in >> p.type >> p.name >> p.width >> p.x >> p.y >> p.invert >> p.port1 >> p.port2 >> p.servoAngle >> p.maxSpeed;
    return in;
}


Profiles::Profiles(QObject *parent) : QObject(parent)
{
    loadFromFile();
}

void Profiles::loadFromFile()
{
    QFile file(qApp->applicationDirPath() + pathToFile);

    if(file.exists())
    {
        file.open(QIODevice::ReadOnly);
        QDataStream in(&file);

        int count; in >> count;

        for(int i = 0; i < count; i++){

            int controlsInProfile = 0; in >> controlsInProfile;
            QVector<Control> prof;
            for(int j = 0; j < controlsInProfile; j++){
                Control con; in >> con;
                prof.push_back(con);
            }
            profiles.push_back(prof);
        }
    }
    file.close();
}

void Profiles::saveToFile()
{
    QFile file(qApp->applicationDirPath() + pathToFile);

    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);

    out << profiles.count();

    for ( auto item : profiles )
    {
        out << item.count();
        for ( auto control : item )
        {
           out << control;
        }
    }
    file.close();
}

void Profiles::addProfile()
{
    QVector<Control> zero;
    profiles.push_back(zero);
}

bool Profiles::deleteProfile(int index)
{
    if(index >= 0 && index < profiles.count()){
        profiles.removeAt(index);
        return true;
    }
    else return false;
}
