#include "socketthread.h"
#include "tcpsocket.h"
socketThread::socketThread(QWidget * parent,qintptr p):QThread (parent)
{
    this->ptr=p;
}
void socketThread::run()
{
    tcpSocket * socket=new tcpSocket(nullptr,this->ptr);//套接字描述符标识tcpSocket
    connect(socket,SIGNAL(sendToThread(QString)),this,SLOT(receiveFromSocket(QString)));
    //要保证signal和slot的参数类型一摸一样,而且不能带参数名称
    socket->waitForBytesWritten();//阻塞，等待socket写数据。直到收到“被写”信号才返回
    while(1)
    socket->waitForReadyRead();//一条语句对应一句话。
}
void socketThread::receiveFromSocket(QString str)
{
    emit(sendToServer(str));
}
