#ifndef SOCKETTHREAD_H
#define SOCKETTHREAD_H
#include <QThread>
#include <QTcpSocket>
#include "tcpsocket.h"
//class tcpSocket;//引入类
class socketThread : public QThread
{
    Q_OBJECT
private:
    qintptr ptr;
    tcpSocket * socket;
public:
    socketThread(QWidget * parent,qintptr ptr);
private slots:
    void receiveFromSocket(QString str);
signals:
    void sendToServer(QString str);
protected:
    virtual void run();//virtual将基类与派生类的同名方法区分开
};

#endif // SOCKETTHREAD_H
