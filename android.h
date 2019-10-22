//#ifndef ANDROID_H
//#define ANDROID_H

//#define FLAG_TRANSLUCENT_STATUS 0x04000000
//#define FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS 0x80000000
//#define SYSTEM_UI_FLAG_LIGHT_STATUS_BAR 0x00002000

//#define SCREEN_ORIENTATION_SENSOR_LANDSCAPE 0x00000006
//#define SCREEN_ORIENTATION_PORTRAIT 0x00000001
//#define SCREEN_ORIENTATION_LANDSCAPE 0x00000000
//#define SCREEN_ORIENTATION_USER 0x00000002
//#define SCREEN_ORIENTATION_SENSOR 0x00000004



//#include <QObject>
//#include <QAndroidJniObject>
//#include <QAndroidJniEnvironment>
//#include <QtAndroid>
//#include <QColor>

//class Android : public QObject
//{
//    Q_OBJECT
//public:
//    explicit Android();

//private:

//signals:

//public slots:

//    bool requestAndroidPermissions() const;

//    void setStatusBarColor(const QColor &color)const;

//    void setNavigationBarColor(const QColor &color)const;

//    void setOrientationPortrait(){
//        QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
//        if ( activity.isValid()) activity.callMethod<void>("setRequestedOrientation", "(I)V", SCREEN_ORIENTATION_PORTRAIT);
//    }

//    void setOrientationSensorLandscape(){
//        QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
//        if ( activity.isValid()) activity.callMethod<void>("setRequestedOrientation", "(I)V", SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
//    }
//};

//#endif // ANDROID_H
