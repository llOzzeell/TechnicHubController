#include "profiles.h"

QDataStream& operator << (QDataStream &out, const Control &p)
{

    out << p.cid
        << p.type
        << p.width
        << p.height
        << p.x
        << p.y
        << p.inverted
        << p.servoAngle
        << p.speedLimit
        << p.port1
        << p.port2
        << p.port3
        << p.port4
        << p.controlledHubName
        << p.controlledHubAddress
        << p.name
        << p.workAsServo
        << p.scaleStep;
    return out;
}

QDataStream& operator >> (QDataStream &in, Control &p)
{
    in >> p.cid
       >> p.type
       >> p.width
       >> p.height
       >> p.x
       >> p.y
       >> p.inverted
       >> p.servoAngle
       >> p.speedLimit
       >> p.port1
       >> p.port2
       >> p.port3
       >> p.port4
       >> p.controlledHubName
       >> p.controlledHubAddress
       >> p.name
       >> p.workAsServo
       >> p.scaleStep;
    return in;
}

QDataStream& operator << (QDataStream &out, const Profile &p)
{
    out << p.name;
    out << p.controls;
    return out;
}

QDataStream& operator >> (QDataStream &in, Profile &p)
{
    in >> p.name;
    in >> p.controls;
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

void Profiles::addProfile(QString name)
{
    Profile p;
    p.setName(name);
    profiles.push_back(p);
    saveFile();
    emit profilesUpdated();
}

void Profiles::deleteProfile(int index)
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

int Profiles::p_getControlsCount(int index)const
{
    if(index < 0 && index > profiles.count()) return -1;
    return profiles[index].getCount();
}

QVariantMap Profiles::p_getControl(int profileIndex, int controlIndex)
{
    if(profileIndex < 0 && profileIndex > profiles.count()) return QVariantMap();
    return profiles[profileIndex].getControlJs(controlIndex);
}

void Profiles::p_addOrUpdateControl(int index, QString cid, QVariantMap jscontrol)
{
    if(index < 0 && index >= profiles.count()) return;

    Control con;
    con.cid = qvariant_cast<QString>(jscontrol.value("cid"));
    con.type = qvariant_cast<quint8>(jscontrol.value("type"));
    con.width = qvariant_cast<quint16>(jscontrol.value("width"));
    con.height = qvariant_cast<quint16>(jscontrol.value("height"));
    con.x = qvariant_cast<quint16>(jscontrol.value("x"));
    con.y = qvariant_cast<quint16>(jscontrol.value("y"));
    con.inverted = qvariant_cast<bool>(jscontrol.value("inverted"));
    con.servoAngle = qvariant_cast<quint8>(jscontrol.value("servoangle"));
    con.speedLimit = qvariant_cast<quint8>(jscontrol.value("speedlimit"));
    con.port1 = qvariant_cast<quint8>(jscontrol.value("port1"));
    con.port2 = qvariant_cast<quint8>(jscontrol.value("port2"));
    con.port3 = qvariant_cast<quint8>(jscontrol.value("port3"));
    con.port4 = qvariant_cast<quint8>(jscontrol.value("port4"));
    con.controlledHubName = qvariant_cast<QString>(jscontrol.value("chName"));
    con.controlledHubAddress = qvariant_cast<QString>(jscontrol.value("chAddress"));
    con.name = qvariant_cast<QString>(jscontrol.value("name"));
    con.workAsServo = qvariant_cast<bool>(jscontrol.value("workAsServo"));
    con.scaleStep = qvariant_cast<int>(jscontrol.value("scaleStep"));
    profiles[index].addOrUpdateControl(cid, con);

    saveFile();
}

void Profiles::p_deleteControl(int index, QString cid)
{
    profiles[index].deleteControl(cid);
    saveFile();
}
