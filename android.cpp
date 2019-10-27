#include "android.h"

Android::Android()
{
    QAndroidJniObject vibroString = QAndroidJniObject::fromString("vibrator");
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
    QAndroidJniObject appctx = activity.callObjectMethod("getApplicationContext","()Landroid/content/Context;");
    vibratorService = appctx.callObjectMethod("getSystemService", "(Ljava/lang/String;)Ljava/lang/Object;", vibroString.object<jstring>());
}

bool Android::requestAndroidPermissions() const
{
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

void Android::setStatusBarColor(const QColor &color) const
{
    if (QtAndroid::androidSdkVersion() < 21) return;

    QtAndroid::runOnAndroidThread([=]()
    {
        QAndroidJniObject window = QtAndroid::androidActivity().callObjectMethod("getWindow", "()Landroid/view/Window;");
        window.callMethod<void>("addFlags", "(I)V", FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        window.callMethod<void>("clearFlags", "(I)V", FLAG_TRANSLUCENT_STATUS);
        window.callMethod<void>("setStatusBarColor", "(I)V", color.rgba());
    });
}

void Android::setNavigationBarColor(const QColor &color) const
{
    if (QtAndroid::androidSdkVersion() < 21) return;

    QtAndroid::runOnAndroidThread([=]()
    {
        QAndroidJniObject window = QtAndroid::androidActivity().callObjectMethod("getWindow", "()Landroid/view/Window;");
        window.callMethod<void>("addFlags", "(I)V", FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
        window.callMethod<void>("clearFlags", "(I)V", FLAG_TRANSLUCENT_STATUS);
        window.callMethod<void>("setNavigationBarColor", "(I)V", color.rgba());
    });
}

void Android::setOrientationPortrait()
{
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
    if ( activity.isValid()) activity.callMethod<void>("setRequestedOrientation", "(I)V", SCREEN_ORIENTATION_PORTRAIT);
}

void Android::setOrientationSensorLandscape()
{
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
    if ( activity.isValid()) activity.callMethod<void>("setRequestedOrientation", "(I)V", SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
}

void Android::setOrientationUser()
{
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
    if ( activity.isValid()) activity.callMethod<void>("setRequestedOrientation", "(I)V", SCREEN_ORIENTATION_USER);
}

void Android::vibrate(int milliseconds) const
{
    if (vibratorService.isValid())vibratorService.callMethod<void>("vibrate", "(J)V", static_cast<jlong>(milliseconds));
}

void Android::vibrateWeak() const
{
    vibrate(15);
}

void Android::vibrateMiddle() const
{
    vibrate(30);
}

void Android::vibrateStrong() const
{
    vibrate(50);
}
