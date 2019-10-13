#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>
#include <QFile>
#include <QDataStream>
#include <QStandardPaths>
#include <QGuiApplication>

class AppSettings: public QObject{
    Q_OBJECT
public:
    AppSettings():darkMode(true), tapTick(true){loadFromFile();}

private:

    QFile file;
    const QString pathToFile = "/config.z";
    bool darkMode;
    bool tapTick;

signals:

    void settingsChanged();

public slots:

    void loadFromFile(){

        auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QFile file(path + pathToFile);

//      QFile file(qApp->applicationDirPath() + pathToFile);

        if(file.exists())
        {
            file.open(QIODevice::ReadOnly);
            QDataStream in(&file);

            in >> darkMode;
            in >> tapTick;
        }
        file.close();
    }

    void saveToFile(){

        auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QFile file(path + pathToFile);

//      QFile file(qApp->applicationDirPath() + pathToFile);

        file.open(QIODevice::WriteOnly);
        QDataStream out(&file);

        out << darkMode;
        out << tapTick;

        file.close();

    }

    bool getDarkMode(){
        return darkMode;
    }

    void setDarkMode(bool value){
        darkMode = value;
        saveToFile();
    }

    bool getTapTick(){
        return tapTick;
    }

    void setTapTick(bool value){
        tapTick = value;
        saveToFile();
    }

};

#endif // APPSETTINGS_H
