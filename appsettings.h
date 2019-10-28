#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QDebug>
#include <QObject>
#include <QFile>
#include <QDataStream>
#include <QStandardPaths>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QString>
#include <QQuickWindow>

#include "translator.h"

class AppSettings: public QObject{
    Q_OBJECT
public:
    AppSettings(QQmlApplicationEngine *engine):darkMode(true), tapTick(true), currentLanguage(0){

        loadFile();
        translator.setEngine(engine);
        setLanguage(currentLanguage);
    }
    ~AppSettings(){window = nullptr;}

private:

    QFile file;
    const QString pathToFile = "/config.cz";
    bool darkMode;
    bool tapTick;
    QQuickWindow *window = nullptr;
    Translator translator;
    int currentLanguage;

signals:

    void themeChanged(bool value);
    void taptickChanged(bool value);


public slots:

    void setWindow(QQuickWindow *_window){
        window = _window;
    }

    void loadFile(){

        auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QFile file(path + pathToFile);

        if(file.exists())
        {
            file.open(QIODevice::ReadOnly);
            QDataStream in(&file);

            in >> darkMode;
            in >> tapTick;
            in >> currentLanguage;
        }
        file.close();
        emit themeChanged(darkMode);
        emit taptickChanged(tapTick);
    }

    void saveFile() const{

        auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QFile file(path + pathToFile);

        file.open(QIODevice::WriteOnly);
        QDataStream out(&file);

        out << darkMode;
        out << tapTick;
        out << currentLanguage;

        file.close();

    }

    bool getDarkMode() const{
        return darkMode;
    }

    void setDarkMode(bool value){
        darkMode = value;
        saveFile();
        emit themeChanged(darkMode);
    }

    bool getTapTick() const{
        return tapTick;
    }

    void setTapTick(bool value){
        tapTick = value;
        saveFile();
        emit taptickChanged(tapTick);
    }

    void setImmersiveMode(bool value){
        if(window != nullptr){
            if(value) window->showFullScreen();
            else window->showNormal();
        }
    }

    void setLanguage(int lang){
        currentLanguage = lang;
        saveFile();

        if(lang == 0){
            translator.selectLanguage("en_US");
        }
        else{
            translator.selectLanguage("ru_RU");
        }

        qDebug() << "CURRENT LANG set: " << currentLanguage;
    }

    int getLanguage(){
        qDebug() << "CURRENT LANG get: " << currentLanguage;
        return currentLanguage;
    }
};

#endif // APPSETTINGS_H
