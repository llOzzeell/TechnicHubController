#ifndef PROFILES_H
#define PROFILES_H

#include <QObject>
#include <QDebug>
#include <QFile>
#include <QDataStream>
#include <QVector>
#include <QGuiApplication>

struct Profile
{
    quint8 type;
    QString name;
    quint8 width;
    quint8 x;
    quint8 y;
    bool invert;
    QString port1;
    QString port2;
    quint8 servoAngle;
    quint8 maxSpeed;

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
    QVector<Profile> profilesVector;


signals:

public slots:

    void loadFromFile();

    void saveToFile();

    int getCount();

    void addProfile();

    void updateProfile(int index, QString name);

    void loadProfile(int index);

};

#endif // PROFILES_H
