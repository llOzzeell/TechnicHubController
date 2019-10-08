#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>

#include "hubfinder.h"
#include "hubconnector.h"
#include "huboperator.h"
//#include "androidext.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

//    AndroidExt afunc;
//    QQmlContext *context_afunc = engine.rootContext();
//    context_afunc ->setContextProperty("androidFunc", &afunc);

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


    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
