#include "tcpserver.h"
#include "tcpsocket.h"
#include "socketthread.h"
tcpServer::tcpServer(QWidget * parent) : QTcpServer(parent)
{

}
void tcpServer::incomingConnection(qintptr socketDescriptor)
{
    socketThread * thread=new socketThread(nullptr,socketDescriptor);
    connect(thread,SIGNAL(sendToServer(QString)),this,SLOT(receiveFromThread(QString)));
    //socketThread将socket描述符传递下去。
    thread->start();
}//该函数连接来临时自动调用。调用时会把socket描述符安排好。
void tcpServer::receiveFromThread(QString str)
{
    emit(sendToMain(str));
}
