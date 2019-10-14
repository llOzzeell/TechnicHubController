#ifndef ANDROIDFUNCTION_H
#define ANDROIDFUNCTION_H
#include <QObject>
#include <QDebug>
#include <QColor>

#ifdef Q_OS_ANDROID
    #include <QAndroidJniObject>
    #include <QAndroidJniEnvironment>
    #include <QtAndroid>
#endif

#define FLAG_TRANSLUCENT_STATUS 0x04000000
#define FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS 0x80000000
#define SYSTEM_UI_FLAG_LIGHT_STATUS_BAR 0x00002000

class AndroidExt: public QObject
{
Q_OBJECT
public:
    AndroidExt(){

#if defined(Q_OS_ANDROID)
    QAndroidJniObject vibroString = QAndroidJniObject::fromString("vibrator");
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
    QAndroidJniObject appctx = activity.callObjectMethod("getApplicationContext","()Landroid/content/Context;");
    vibratorService = appctx.callObjectMethod("getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;", vibroString.object<jstring>());
#endif

    }

private:
#if defined(Q_OS_ANDROID)
    QAndroidJniObject vibratorService;
#endif

public slots:

    void setStatusBarColor(const QColor &color){

        if (QtAndroid::androidSdkVersion() < 21) return;

        QtAndroid::runOnAndroidThread([=]()
        {
            QAndroidJniObject window = QtAndroid::androidActivity().callObjectMethod("getWindow", "()Landroid/view/Window;");
            window.callMethod<void>("addFlags", "(I)V", FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.callMethod<void>("clearFlags", "(I)V", FLAG_TRANSLUCENT_STATUS);
            window.callMethod<void>("setStatusBarColor", "(I)V", color.rgba()); // Desired statusbar color
        });
    }

    void setTheme(const int theme){

        if (QtAndroid::androidSdkVersion() < 23) return;

        QtAndroid::runOnAndroidThread([=]()
        {
            QAndroidJniObject window = QtAndroid::androidActivity().callObjectMethod("getWindow", "()Landroid/view/Window;");
            QAndroidJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
                    int visibility = view.callMethod<int>("getSystemUiVisibility", "()I");
                    if (!theme)
                        visibility |= SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
                    else
                        visibility &= ~SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
                    view.callMethod<void>("setSystemUiVisibility", "(I)V", visibility);
        });
    }

    void setOrientation(QString orientation)
    {
        int ori = 0;
        if(orientation == "portraite") ori = 1;
        if(orientation == "landscape") ori = 0;
        if(orientation == "any") ori = -1;

        QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
        if ( activity.isValid() )
        {
            activity.callMethod<void>("setRequestedOrientation"
                     , "(I)V" // signature
                     , ori);
        }
    }

    void vibrate(int milliseconds) {

        if (vibratorService.isValid()) {
                jlong ms = milliseconds;
                //jboolean hasvibro = vibratorService.callMethod<jboolean>("hasVibrator", "()Z");
                vibratorService.callMethod<void>("vibrate", "(J)V", ms);
        } else qDebug() << "No vibrator service available";
    }

    bool requestAndroidPermissions(){

        const QVector<QString> permissions({"android.permission.ACCESS_COARSE_LOCATION",
                                            "android.permission.BLUETOOTH",
                                            "android.permission.BLUETOOTH_ADMIN",
                                            "android.permission.VIBRATE",
                                            "android.permission.WRITE_EXTERNAL_STORAGE",
                                            "android.permission.READ_EXTERNAL_STORAGE"});

        for(const QString &permission : permissions){
            auto result = QtAndroid::checkPermission(permission);

            if(result == QtAndroid::PermissionResult::Denied){
                auto resultHash = QtAndroid::requestPermissionsSync(QStringList({permission}));
                if(resultHash[permission] == QtAndroid::PermissionResult::Denied)
                    return false;
            }
        }

        return true;
    }
};

#endif // ANDROIDFUNCTION_H
