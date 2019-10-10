#ifndef ANDROIDFUNCTION_H
#define ANDROIDFUNCTION_H
#include <QObject>
#include <QDebug>

//#ifdef Q_OS_ANDROID
//    #include <QAndroidJniObject>
//    #include <QAndroidJniEnvironment>
//    #include <QtAndroid>
//#endif

class AndroidExt: public QObject
{
Q_OBJECT
public:
    AndroidExt(){}

private:

public slots:

//    void setOrientation(QString orientation)
//    {
//        int ori = 0;
//        if(orientation == "portraite") ori = 1;
//        if(orientation == "landscape") ori = 0;
//        if(orientation == "any") ori = -1;

//        QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");
//        if ( activity.isValid() )
//        {
//            activity.callMethod<void>("setRequestedOrientation"
//                     , "(I)V" // signature
//                     , ori);
//        }
//    }
};

#endif // ANDROIDFUNCTION_H
