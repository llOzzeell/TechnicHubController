#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "finder.h"
#include "connector.h"
#include "favoritedevices.h"
#include "android.h"
#include "appsettings.h"
#include "translator.h"
#include "profiles.h"

int main(int argc, char *argv[])
{

    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Android andr;
    if(!andr.requestAndroidPermissions())return -1;
    engine.rootContext()->setContextProperty("cpp_Android", &andr);

    FavoriteDevices fav;
    engine.rootContext()->setContextProperty("cpp_Favorite", &fav);

    Connector connector(&fav);
    engine.rootContext()->setContextProperty("cpp_Connector", &connector);

    Finder finder(&connector, &fav);
    engine.rootContext()->setContextProperty("cpp_Finder", &finder);

    QObject::connect(&finder, &Finder::devicesListUpdated, &connector, &Connector::setFoundList);

    AppSettings appsett;
    engine.rootContext()->setContextProperty("cpp_Settings", &appsett);

    Profiles prof;
    engine.rootContext()->setContextProperty("cpp_Profiles", &prof);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    //QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());

    return app.exec();
}
