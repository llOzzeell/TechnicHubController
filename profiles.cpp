#include "profiles.h"

Profiles::Profiles(QObject *parent) : QObject(parent)
{
    //Profile p{0,"str",140,14,88,false,"A","C",90,100};
    //profilesVector.append(p);
    //saveToFile();
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

        for(int i = 0; i < count; i ++){
            Profile p; in >> p;
            profilesVector.append(p);
        }
    }
    file.close();

//    Profile p = profilesVector.at(0);
//    qDebug() << p.type;
//    qDebug() << p.name;
//    qDebug() << p.width;
//    qDebug() << p.x;
//    qDebug() << p.y;
//    qDebug() << p.invert;
//    qDebug() << p.port1;
//    qDebug() << p.port2;
//    qDebug() << p.servoAngle;
//    qDebug() << p.maxSpeed;
}

void Profiles::saveToFile()
{
    QFile file(qApp->applicationDirPath() + pathToFile);

    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);

    out << profilesVector.count();

    for ( auto item : profilesVector )
    {
       out << item;
    }
    file.close();
}

int Profiles::getCount()
{
    return profilesVector.count();
}

void Profiles::addProfile()
{

}

void Profiles::updateProfile(int index, QString name)
{

}

void Profiles::loadProfile(int index)
{

}

// перегрузка операторов структур данных
QDataStream& operator<<(QDataStream &out, Profile &p)
{
    out << p.type << p.name << p.width << p.x << p.y << p.invert << p.port1 << p.port2 << p.servoAngle << p.maxSpeed;
    return out;
}

QDataStream& operator>>(QDataStream &in, Profile &p)
{
    in >> p.type >> p.name >> p.width >> p.x >> p.y >> p.invert >> p.port1 >> p.port2 >> p.servoAngle >> p.maxSpeed;
    return in;
}
