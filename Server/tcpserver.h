#ifndef TCPSERVER_H
#define TCPSERVER_H
#include <QTcpServer>
class tcpServer : public QTcpServer
{
    Q_OBJECT
public:
    tcpServer(QWidget * parent);//构造函数，QT中QWidget是所有类的父类
protected:
    virtual void incomingConnection(qintptr socketDescriptor);//socket描述符
signals:
    void sendToMain(QString str);
private slots:
    void receiveFromThread(QString str);
};

#endif // TCPSERVER_H
