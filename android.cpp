#include "android.h"

Android::Android()
{

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
