#ifndef ANDROID_H
#define ANDROID_H

#define FLAG_TRANSLUCENT_STATUS 0x04000000
#define FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS 0x80000000
#define SYSTEM_UI_FLAG_LIGHT_STATUS_BAR 0x00002000

#define SCREEN_ORIENTATION_SENSOR_LANDSCAPE 0x00000006
#define SCREEN_ORIENTATION_PORTRAIT 0x00000001
#define SCREEN_ORIENTATION_LANDSCAPE 0x00000000
#define SCREEN_ORIENTATION_USER 0x00000002
#define SCREEN_ORIENTATION_SENSOR 0x00000004

#include <QObject>
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#include <QtAndroid>
#include <QColor>
#include <QDebug>
#include <QDesktopServices>
#include <QUrl>

class Android : public QObject
{
    Q_OBJECT
public:
    explicit Android();

private:

    QAndroidJniObject vibratorService;

signals:

public slots:

    bool requestAndroidPermissions() const;

    void setStatusBarColor(const QColor &color)const;

    void setNavigationBarColor(const QColor &color)const;

    void setOrientationPortrait();

    void setOrientationSensorLandscape();

    void setOrientationUser();

    void vibrate(int milliseconds) const;

    void vibrateWeak() const;

    void vibrateMiddle() const;

    void vibrateStrong() const;

    void rateApp(){
        QString link = "market://details?id=pro.controlz";
        QDesktopServices::openUrl(QUrl(link));
    }

    void forumLink(){
        QString link = "https://www.eurobricks.com/forum/index.php?/forums/topic/173892-controlz-my-app-for-control-electric/";
        QDesktopServices::openUrl(QUrl(link));
    }
};

#endif // ANDROID_H
