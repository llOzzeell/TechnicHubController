#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "smarthubfinder.h"
#include "hubconnector.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    SmartHubFinder hubFinder;
    hubFinder.setDebugOut(false);
    QQmlContext *context_hubFinder = engine.rootContext();
    context_hubFinder ->setContextProperty("smartHubFinder", &hubFinder);

    Hubconnector hubconnector(&hubFinder);
    hubconnector.setDebugOut(false);
    QQmlContext *context_hubconnector= engine.rootContext();
    context_hubconnector ->setContextProperty("smartHubConnector", &hubconnector);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
