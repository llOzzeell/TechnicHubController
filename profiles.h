#ifndef PROFILES_H
#define PROFILES_H

#include <QObject>
#include <QDataStream>
#include <QFile>
#include <QStandardPaths>

struct Control{
    quint8 type = 0xff;
    quint16 width = 0; quint16 x = 0; quint16 y = 0;
    bool inverted = false;
    quint8 servoAngle = 0;
    quint8 speedLimit = 0;
    bool orientationVertical = false;
    quint8 port1;
    quint8 port2;
    quint8 port3;
    quint8 port4;

    friend QDataStream& operator <<(QDataStream &out, Control &p);
    friend QDataStream& operator >>(QDataStream &in, Control &p);
};

class Profile{
public:
    Profile(QString _name = ""): name(_name){}

    QString getName(){return name;}
    void setName(QString _name){name = _name;}

    void clearProfile(){controls.clear();}
    void addControl(Control &con){controls.push_back(con);}
    Control& getControl(int index){ return controls[index]; }
    int getCount(){return controls.count(); }

private:
    QString name;
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

signals:

    void profilesUpdated();

public slots:

    void loadFile();

    void saveFile();

    QList<QString> getProfilesList();

    void addNew(QString name);

    void deleteOne(int index);

    void changeName(int index, QString _new);
};

#endif // PROFILES_H
