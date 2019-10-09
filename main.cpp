#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>

#include "hubfinder.h"
#include "hubconnector.h"
#include "huboperator.h"
#include "profiles.h"
#ifdef Q_OS_ANDROID
    #include "androidext.h"
#endif
int main(int argc, char *argv[])
{
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



    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
