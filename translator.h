#ifndef TRANSLATOR_H
#define TRANSLATOR_H
#include <QObject>
#include <QTranslator>
#include <QQmlApplicationEngine>
#include <QGuiApplication>

class Translator: public QObject{
    Q_OBJECT

    public:
     Translator(QQmlApplicationEngine *_engine) {
        engine = _engine;
        translator = new QTranslator(this);
     }
     ~Translator(){ delete translator;  delete engine;}

private:
     QTranslator *translator = nullptr;
     QQmlApplicationEngine *engine;


public slots:

     void selectLanguage(QString language) {

         if(language == "ru_RU"){

             if (!translator->isEmpty()) qApp->removeTranslator(translator);

             translator->load(":/lang/lang_ru_RU");
             qApp->installTranslator(translator);
         }

         if(language == "en_US"){

            if (!translator->isEmpty())qApp->removeTranslator(translator);
         }

         engine->retranslate();

    }
};

#endif // TRANSLATOR_H
