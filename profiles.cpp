#include "profiles.h"

QDataStream& operator<<(QDataStream &out, Control &p)
{

    out << p.type << p.width << p.x << p.y << p.inverted << p.servoAngle << p.speedLimit << p.orientationVertical << p.port1 << p.port2 << p.port3 << p.port4;
    return out;
}

QDataStream& operator>>(QDataStream &in, Control &p)
{
    in >> p.type >> p.width >> p.x >> p.y >> p.inverted >> p.servoAngle >> p.speedLimit >> p.orientationVertical >> p.port1 >> p.port2 >> p.port3 >> p.port4;
    return in;
}

QDataStream& operator<<(QDataStream &out, Profile &p)
{
    out << p.name << p.controls.count();
    for(auto con : p.controls){
        out << con;
    }
    return out;
}

QDataStream& operator>>(QDataStream &in, Profile &p)
{
    in >> p.name;
    int controlsCount; in >> controlsCount;
    for(int i = 0; i < controlsCount; i++){
        Control con; in >> con;
        p.controls.push_back(con);
    }
    return in;
}

Profiles::Profiles(QObject *parent) : QObject(parent)
{
    loadFile();
}

void Profiles::loadFile()
{
    auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
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

void Profiles::saveFile()
{
    auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
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

QList<QString> Profiles::getProfilesList()
{
    QStringList list;
    for(auto profile : profiles){
        list.append(profile.getName());
    }
    return std::move(list);
}

void Profiles::addNew(QString name)
{
    Profile p;
    p.setName(name);
    profiles.push_back(p);
    saveFile();
    emit profilesUpdated();
}

void Profiles::deleteOne(int index)
{
    if(index < 0 && index > profiles.count()) return;

    profiles.remove(index);
    saveFile();
    emit profilesUpdated();
}

void Profiles::changeName(int index, QString _new)
{
    if(index < 0 && index > profiles.count()) return;

    profiles[index].setName(_new);
    saveFile();
    emit profilesUpdated();
}
