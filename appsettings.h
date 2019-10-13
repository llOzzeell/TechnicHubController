#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QDebug>
#include <QObject>
#include <QFile>
#include <QDataStream>
#include <QStandardPaths>
#include <QGuiApplication>

class AppSettings: public QObject{
    Q_OBJECT
public:
    AppSettings():darkMode(true), tapTick(true), language(0), langOverride(false){ loadFromFile();}

private:

    QFile file;
    const QString pathToFile = "/config.z";
    bool darkMode;
    bool tapTick;
    int language;
    bool langOverride;

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
            in >> language;
            in >> langOverride;
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
        out << language;
        out << langOverride;

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

    int getLanguage(){

        return language;
    }

    void setLanguage(int value){

        language = value;
        langOverride = true;
        saveToFile();
    }

    bool isLanguageOverrided(){

        return langOverride;
    }

};

#endif // APPSETTINGS_H
