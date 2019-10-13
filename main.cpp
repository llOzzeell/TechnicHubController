#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>
#include <QQuickWindow>

#include "hubfinder.h"
#include "hubconnector.h"
#include "huboperator.h"
#include "profiles.h"
#include "appsettings.h"
#include "translator.h"

#if defined (Q_OS_ANDROID)
#include <QtAndroid>
#include "androidext.h"

bool requestAndroidPermissions(){

    const QVector<QString> permissions({"android.permission.ACCESS_COARSE_LOCATION",
                                        "android.permission.BLUETOOTH",
                                        "android.permission.BLUETOOTH_ADMIN",
                                        "android.permission.VIBRATE",
                                        "android.permission.WRITE_EXTERNAL_STORAGE",
                                        "android.permission.READ_EXTERNAL_STORAGE"});

    for(const QString &permission : permissions){
        auto result = QtAndroid::checkPermission(permission);

        if(result == QtAndroid::PermissionResult::Granted)qDebug() << permission << " " << "GRANTED";
        else qDebug() << permission << " " << "DENIED";


        if(result == QtAndroid::PermissionResult::Denied){
            auto resultHash = QtAndroid::requestPermissionsSync(QStringList({permission}));
            if(resultHash[permission] == QtAndroid::PermissionResult::Denied)
                return false;
        }
    }

    return true;
}
#endif

int main(int argc, char *argv[])
{
#if defined (Q_OS_ANDROID)
    if(!requestAndroidPermissions())
        return -1;
#endif

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

#ifdef Q_OS_ANDROID
    AndroidExt afunc;
    QQmlContext *context_afunc = engine.rootContext();
    context_afunc ->setContextProperty("androidFunc", &afunc);
#endif

    HubFinder hubFinder;
    hubFinder.setDebugOut(false);
    QQmlContext *context_hubFinder = engine.rootContext();
    context_hubFinder ->setContextProperty("hubFinder", &hubFinder);

    Hubconnector hubconnector(&hubFinder);
    hubconnector.setDebugOut(false);
    QQmlContext *context_hubconnector = engine.rootContext();
    context_hubconnector ->setContextProperty("hubConnector", &hubconnector);

    HubOperator hubOperator;
    hubOperator.setDebugOut(false);
    QQmlContext *context_huboperator = engine.rootContext();
    context_huboperator ->setContextProperty("hubOperator", &hubOperator);

    QObject::connect(&hubconnector, &Hubconnector::hubLinkUpdate, &hubOperator, &HubOperator::setHubLink);

    Profiles prof;
    QQmlContext *context_prof = engine.rootContext();
    context_prof ->setContextProperty("profilesController", &prof);

    AppSettings appsett;
    QQmlContext *context_appsett = engine.rootContext();
    context_appsett->setContextProperty("appSett", &appsett);

    Translator tran(&engine);
    QQmlContext *context = engine.rootContext();
    context->setContextProperty("translator", &tran);

    if(!appsett.isLanguageOverrided()){

        QString locale = QLocale::system().name();

        if(locale == "en_US" || locale != "en_EN")appsett.setLanguage(0);
        if(locale == "ru_RU")   appsett.setLanguage(1);
        if(locale == "de_DE")   appsett.setLanguage(2);

        if(locale != "en_US" && locale != "en_EN" && locale != "ru_RU" && locale != "de_DE"){
            tran.selectLanguage("en_US");
        }
        else tran.selectLanguage(locale);
    }
    else{

        int lang = appsett.getLanguage();

        if(lang == 0) tran.selectLanguage("en_US");
        if(lang == 1) tran.selectLanguage("ru_RU");
        if(lang == 2) tran.selectLanguage("de_DE");
    }

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

//    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());
//    window->showFullScreen();

    return app.exec();
}
