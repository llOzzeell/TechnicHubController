#ifndef FAVORITEDEVICES_H
#define FAVORITEDEVICES_H

#include <QDebug>
#include <QObject>
#include <QDataStream>
#include <QFile>
#include <QStandardPaths>

struct Favorite{
    Favorite(){}
    Favorite(QString n, int t, QString a){name = n; type = t; address = a;}
    QString name = "";
    int type = -1;
    QString address = "";

    friend QDataStream& operator << (QDataStream &out, Favorite &f);
    friend QDataStream& operator >> (QDataStream &in, Favorite &f);

};

class FavoriteDevices : public QObject
{
    Q_OBJECT

public:

    explicit FavoriteDevices(QObject *parent = nullptr);

private:

    QDataStream stream;
    QVector<Favorite> favoriteList;

signals:

    void loaded();

public slots:

    void loadFile();

    void saveFile();

    void pushNew(QString name, int type, QString address);

    bool deleteFavorite(QString address);

    bool isEmpty();

    int getCount();

    QStringList getFavoriteDevice(int index);

    void updateName(QString name, QString address);

    bool isFavorite(QString address);

    QString getName(QString address);
};

#endif // FAVORITEDEVICES_H
