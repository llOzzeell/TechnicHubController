#include "favoritedevices.h"

QDataStream& operator << (QDataStream &out, Favorite &f){
    out << f.name << f.type << f.address;
    return out;
}

QDataStream& operator >> (QDataStream &in, Favorite &f){
    in >> f.name >> f.type >> f.address;
    return in;
}

FavoriteDevices::FavoriteDevices(QObject *parent) : QObject(parent)
{
    loadFile();
}

void FavoriteDevices::loadFile()
{
    QFile file(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/favoriteList.dat");
    if(!file.exists()) return;
    file.open(QIODevice::ReadOnly);
    QDataStream in(&file);

    int count; in >> count;

    for(int i = 0; i < count; i++){
        Favorite f;
        in >> f;
        favoriteList.push_back(f);
    }

    file.close();

    emit loaded();
}

void FavoriteDevices::saveFile()
{
    QFile file(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/favoriteList.dat");
    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);

    out << favoriteList.count();

    for(Favorite f : favoriteList){
        out << f;
    }

    file.close();
}

void FavoriteDevices::pushNew(QString name, int type, QString address)
{
    for(Favorite f : favoriteList){
        if(address == f.address)return;
    }

    favoriteList.push_back(Favorite{name, type, address});
    saveFile();
}

bool FavoriteDevices::deleteFavorite(QString address)
{
    int i = 0;
    for(Favorite f : favoriteList){
        if(f.address == address){
            favoriteList.remove(i);
            saveFile();
            return true;
        }
        i++;

    }
    saveFile();
    return false;
}

bool FavoriteDevices::isEmpty()
{
    return favoriteList.isEmpty();
}

int FavoriteDevices::getCount()
{
    return favoriteList.count();
}

QStringList FavoriteDevices::getFavoriteDevice(int index)
{
    if(index >= 0 && index < favoriteList.count()){
        QStringList list;
        list.append(favoriteList[index].name);
        list.append(QString::number(favoriteList[index].type));
        list.append(favoriteList[index].address);
        return list;
    }
    return QStringList();
}

void FavoriteDevices::updateName(QString name, QString address)
{
    int i = 0;
    for(Favorite f : favoriteList){
        if(f.address == address){
            favoriteList[i].name = name;
        }
        i++;

    }
    saveFile();
}

bool FavoriteDevices::isFavorite(QString address)
{
    for(Favorite f : favoriteList){
        if(f.address == address){
            return true;
        }
    }
    return false;
}

QString FavoriteDevices::getName(QString address)
{
    for(Favorite f : favoriteList){
        if(f.address == address){
            return f.name;
        }
    }
    return "";
}
