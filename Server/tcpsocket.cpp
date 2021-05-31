#include "tcpsocket.h"
#include <QByteArray>
#include <QString>
#include <QDebug>
#include <QMessageBox>
//class.cpp的作用就是重写构造函数、父类的方法和新定义的方法
tcpSocket::tcpSocket(QWidget * parent,qintptr p):QTcpSocket(parent){
    this->setSocketDescriptor(p);
    on_connected();
    connect(this,SIGNAL(disconnected()),this,SLOT(on_disconnnected()));
    connect(this,SIGNAL(readyRead()),this,SLOT(on_socketReadyRead()));
    //为什么没有onConnected，我猜原因是一旦建立了tcpsocket，必然会被连接。
}//构造函数后:作用为初始化成员变量
//构造函数中的内容使对象一被创建出来就要干的事情。

void tcpSocket::on_connected()
{
    QString msg="成功连接";
    QByteArray arr=msg.toUtf8();
    arr.append('\n');
    this->write(arr);
}
void tcpSocket::on_disconnnected()
{

}
void tcpSocket::on_socketReadyRead()
{
    while(this->canReadLine())
    {
        QByteArray arr=this->readLine();
        qDebug()<<arr;
        emit(sendToThread(arr));
    }
}
