#ifndef ANDROID_H
#define ANDROID_H

#include <QObject>
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#include <QtAndroid>

class Android : public QObject
{
    Q_OBJECT
public:
    explicit Android();

private:

signals:

public slots:

    bool requestAndroidPermissions() const;

};

#endif // ANDROID_H
