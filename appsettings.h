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
    AppSettings(QQmlApplicationEngine *engine):darkMode(true), tapTick(true), hubInfo(true), gridSnap(true), controlsLabelVisible(true), currentLanguage(0){

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
    bool hubInfo;
    QQuickWindow *window = nullptr;
    Translator translator;
    bool gridSnap;
    bool controlsLabelVisible;
    int currentLanguage;


signals:

    void themeChanged(bool value);
    void taptickChanged(bool value);
    void hubInfoChanged(bool value);
    void controlsLabelVisibleChanged(bool value);

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
            in >> hubInfo;
            in >> controlsLabelVisible;
            in >> gridSnap;
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
        out << hubInfo;
        out << controlsLabelVisible;
        out << gridSnap;

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

    bool getHubInfo() const{
        return hubInfo;
    }

    void setHubInfo(bool value){
        hubInfo = value;
        saveFile();
        emit hubInfoChanged(hubInfo);
    }

    bool getControlsLabelsVisible() const{
        return controlsLabelVisible;
    }

    void setControlsLabelsVisible(bool value){
        controlsLabelVisible = value;
        saveFile();
        emit controlsLabelVisibleChanged(controlsLabelVisible);
    }

    bool getGridSnap(){
        return gridSnap;
    }

    void setGridSnap(bool value){
        gridSnap = value;
        saveFile();
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
    }

    int getLanguage(){
        return currentLanguage;
    }
};

#endif // APPSETTINGS_H
