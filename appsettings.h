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

#include "translator.h"

struct langStruct{
    QString locale;
    QString langName;
};

class AppSettings: public QObject{
    Q_OBJECT
public:
    AppSettings(QQmlApplicationEngine *_engine):darkMode(true), tapTick(true), language(0), langOverride(false){

        locales.append(qMakePair(0,langStruct{QString("en_US"),QString("English")}));
        locales.append(qMakePair(1,langStruct{QString("ru_RU"),QString("Русский")}));
        locales.append(qMakePair(2,langStruct{QString("de_DE"),QString("Deutsch")}));

        loadFromFile();

        translator = new Translator(_engine);

        loadLanguage();
    }
    ~AppSettings(){delete translator;}

private:

    QFile file;
    const QString pathToFile = "/config.z";
    bool darkMode;
    bool tapTick;
    Translator *translator;
    int language;
    bool langOverride;
    QVector<QPair<int,langStruct>> locales;

signals:

    void settingsChanged();

public slots:

    void loadFromFile(){

        auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QFile file(path + pathToFile);

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

    void saveToFile() const{

        auto path = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
        QFile file(path + pathToFile);

        file.open(QIODevice::WriteOnly);
        QDataStream out(&file);

        out << darkMode;
        out << tapTick;
        out << language;
        out << langOverride;

        file.close();

    }

    ///////////////////////////////////////////////////////

    bool getDarkMode() const{
        return darkMode;
    }

    void setDarkMode(bool value){
        darkMode = value;
        saveToFile();
    }

    ///////////////////////////////////////////////////////

    bool getTapTick() const{
        return tapTick;
    }

    void setTapTick(bool value){
        tapTick = value;
        saveToFile();
    }

    ///////////////////////////////////////////////////////

    void loadLanguage(){

        if(!langOverride){

            QString locale = QLocale::system().name();

            for(auto pair : locales){
                if(pair.second.locale == locale){ setLanguage(pair.first); return; }
            }
        }
        else{

            for(auto pair : locales){
                if(pair.first == language){ translator->selectLanguage(locales[language].second.locale); return; }
            }
        }
    }

    int getCurrentLanguageInt() const{

        return language;
    }

    QString getCurrentLanguageLocaleString() const{

        return locales[language].second.locale;
    }

    QString getCurrentLanguageNameString() const{

        return locales[language].second.langName;
    }

    QStringList getLocales() const{
        QStringList list;
        for(auto pair : locales){
            list.append(pair.second.locale);
        }
        return list;
    }

    QStringList getNames() const{
        QStringList list;
        for(auto pair : locales){
            list.append(pair.second.langName);
        }
        return list;
    }

    void setLanguage(int value){

        language = value;
        langOverride = true;
        translator->selectLanguage(locales[language].second.locale);
        saveToFile();
    }

    bool isLanguageOverrided() const{

        return langOverride;
    }

};

#endif // APPSETTINGS_H
