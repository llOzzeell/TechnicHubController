#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "finder.h"
#include "connector.h"
#include "favoritedevices.h"
#include "android.h"

int main(int argc, char *argv[])
{

    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Android andr;
    if(!andr.requestAndroidPermissions())return -1;
    QQmlContext *context0;
    context0 = engine.rootContext();
    context0->setContextProperty("cpp_Android", &andr);

    FavoriteDevices fav;
    QQmlContext *context3;
    context3 = engine.rootContext();
    context3->setContextProperty("cpp_Favorite", &fav);

    Connector connector(&fav);
    QQmlContext *context2;
    context2 = engine.rootContext();
    context2->setContextProperty("cpp_Connector", &connector);

    Finder finder(&connector, &fav);
    QQmlContext *context;
    context = engine.rootContext();
    context->setContextProperty("cpp_Finder", &finder);

    QObject::connect(&finder, &Finder::devicesListUpdated, &connector, &Connector::setFoundList);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
