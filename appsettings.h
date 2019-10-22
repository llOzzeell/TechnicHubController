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
    AppSettings():darkMode(true), tapTick(true){
        loadFile();
    }
    ~AppSettings(){delete window;}

private:

    QFile file;
    const QString pathToFile = "/config.cz";
    bool darkMode;
    bool tapTick;
    QQuickWindow *window = nullptr;

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
};

#endif // APPSETTINGS_H
