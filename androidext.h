#ifndef ANDROIDFUNCTION_H
#define ANDROIDFUNCTION_H
#include <QObject>
//#include <QtAndroid>
#include <QDebug>

class AndroidExt: public QObject
{
Q_OBJECT
public:
    AndroidExt(){}

private:

public slots:

    void setOrientation(QString orientation)
    {
        int ori = 0;
        if(orientation == "portraite") ori = 1;
        if(orientation == "landscape") ori = 0;
        if(orientation == "any") ori = -1;

//        QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
//        if ( activity.isValid() )
//        {
//            activity.callMethod<void>("setRequestedOrientation"
//                     , "(I)V" // signature
//                     , ori);
//        }
    }

    static bool requestAndroidPermissions(){
    //Request requiered permissions at runtime

    const QVector<QString> permissions({
                                        "android.permission.WRITE_EXTERNAL_STORAGE",
                                        "android.permission.READ_EXTERNAL_STORAGE"});

//    for(const QString &permission : permissions){
//        auto result = QtAndroid::checkPermission(permission);
//        if(result == QtAndroid::PermissionResult::Denied){
//            auto resultHash = QtAndroid::requestPermissionsSync(QStringList({permission}));
//            if(resultHash[permission] == QtAndroid::PermissionResult::Denied)
//                return false;
//        }
//    }

    return true;
    }

};

#endif // ANDROIDFUNCTION_H
