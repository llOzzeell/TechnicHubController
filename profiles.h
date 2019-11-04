#ifndef PROFILES_H
#define PROFILES_H

#include <QDebug>
#include <QObject>
#include <QDataStream>
#include <QFile>
#include <QHash>
#include <QVariantMap>
#include <QStandardPaths>

struct Control{

    quint8 type = 0;
    quint16 width = 0;
    quint16 height = 0;
    quint16 x = 0;
    quint16 y = 0;
    bool inverted = false;
    quint8 servoAngle = 0;
    quint8 speedLimit = 0;
    quint8 port1;
    quint8 port2;
    quint8 port3;
    quint8 port4;
    QString cid = "";
    QString controlledHubName = "";
    QString controlledHubAddress = "";
    QString name = "";
    bool workAsServo = false;
    int scaleStep = 0;

    friend QDataStream& operator <<(QDataStream &out, const Control &p);
    friend QDataStream& operator >>(QDataStream &in, Control &p);
};

////////////////////////////////////////////////////////////////

class Profile{

public:
    Profile(QString _name = ""): name(_name){}

    QString getName(){return name;}

    void setName(QString _name){name = _name;}

    void clearProfile(){controls.clear();}

    //////////////////////////////////////////////

    int getCount()const{
        return controls.count();
    }

    void addOrUpdateControl(QString cid, Control &con){
        if(controls.contains(cid)){
            deleteControl(cid);
        }
        controls.insert(cid, con);
    }

    void deleteControl(QString cid){
        controls.remove(cid);
    }

    QVariantMap getControlJs(int index){
        Control con = getControl(index);
        QVariantMap var;
        var.insert("cid", con.cid);
        var.insert("type", con.type);
        var.insert("width", con.width);
        var.insert("height", con.height);
        var.insert("x", con.x);
        var.insert("y", con.y);
        var.insert("inverted", con.inverted);
        var.insert("servoangle", con.servoAngle);
        var.insert("speedlimit", con.speedLimit);
        var.insert("port1", con.port1);
        var.insert("port2", con.port2);
        var.insert("port3", con.port3);
        var.insert("port4", con.port4);
        var.insert("chName", con.controlledHubName);
        var.insert("chAddress", con.controlledHubAddress);
        var.insert("name", con.name);
        var.insert("workAsServo", con.workAsServo);
        var.insert("scaleStep", con.scaleStep);
        return var;
    }

private:
    QString name;
    QHash<QString,Control> controls;

    Control getControl(int index){
        auto it = controls.cbegin();
        std::advance(it, index);
        return controls[it.key()];
    }

    friend QDataStream& operator<<(QDataStream &out, const Profile &p);
    friend QDataStream& operator>>(QDataStream &in, Profile &p);
};

///////////////////////////////////////////////////////////////

class Profiles : public QObject
{
    Q_OBJECT
public:
    explicit Profiles(QObject *parent = nullptr);

private:

    QFile file;
    const QString pathToFile = "/profiles.dat";
    QVector<Profile> profiles;

signals:

    void profilesUpdated();

public slots:

    void loadFile();

    void saveFile();

    QList<QString> getProfilesList();

    void addProfile(QString name);

    void deleteProfile(int index);

    void changeName(int index, QString _new);

    ////////////////////////////////////////////////////

    int p_getControlsCount(int index) const;

    QVariantMap p_getControl(int profileIndex, int controlIndex);

    void p_addOrUpdateControl(int index, QString cid, QVariantMap jscontrol);

    void p_deleteControl(int index, QString cid);

};

#endif // PROFILES_H
