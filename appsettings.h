#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>
#include <QFile>
#include <QDataStream>
#include <QGuiApplication>

class AppSettings: public QObject{
    Q_OBJECT
public:
    AppSettings():darkMode(true){loadFromFile();}

private:

    QFile file;
    const QString pathToFile = "/config3.dat";
    bool darkMode;

signals:

    void settingsChanged();

public slots:

    void loadFromFile(){

        //auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        //QFile file(path + pathToFile);

        QFile file(qApp->applicationDirPath() + pathToFile);

        if(file.exists())
        {
            file.open(QIODevice::ReadOnly);
            QDataStream in(&file);

            in >> darkMode;
        }
        file.close();
    }

    void saveToFile(){

        //auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        //QFile file(path + pathToFile);

        QFile file(qApp->applicationDirPath() + pathToFile);

        file.open(QIODevice::WriteOnly);
        QDataStream out(&file);

        out << darkMode;

        file.close();

    }

    bool getDarkMode(){
        return darkMode;
    }

    void setDarkMode(bool value){
        darkMode = value;
        saveToFile();
    }

};

#endif // APPSETTINGS_H
