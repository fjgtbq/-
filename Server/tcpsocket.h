#ifndef TCPSOCKET_H
#define TCPSOCKET_H
#include <QTcpSocket>
#include "ui_mainwindow.h"
#include "transobj.h"
class tcpSocket : public QTcpSocket
{
    Q_OBJECT
public:
    tcpSocket(QWidget * parent,qintptr p);
private slots:
    void on_disconnnected();
    void on_socketReadyRead();
public:
    void on_connected();
signals://层层连接，父与子
    void sendToThread(QString str);
};

#endif // TCPSOCKET_H
