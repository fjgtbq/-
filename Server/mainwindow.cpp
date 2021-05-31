#include "mainwindow.h"
#include "socketthread.h"
#include "tcpserver.h"
#include "ui_mainwindow.h"
#include <QQuickItem>


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)//执行父类QMainWindow的构造函数，创建一个Ui::MainWindow类的对象ui。
{
    ui->setupUi(this);
    ui->spinBox->setValue(30);
    ui->view->setSource(QUrl("qrc:/main.qml"));
    ui->view->setResizeMode(QQuickWidget::SizeRootObjectToView);
    LabListen=new QLabel("监听状态");
    LabListen->setMinimumWidth(150);
    ui->statusBar->addWidget(LabListen);

    QString localIP=getLocalIP();
    this->setWindowTitle(this->windowTitle()+"----本机IP："+localIP);
    ui->comboBox->addItem(localIP);
    server=new tcpServer(this);//创建实例
}

MainWindow::~MainWindow()
{
    delete ui;
}
QString MainWindow::getLocalIP()
{
    QString hostName=QHostInfo::localHostName();//返回本机主机名
    QHostInfo hostInfo=QHostInfo::fromName(hostName);//返回指定主机名的IP地址
    QString localIP="";
    QList<QHostAddress> addList=hostInfo.addresses();//一个QHostAddress类型的列表
    if(!addList.empty())
    {
        for(int i=0;i<addList.count();i++)
        {
            QHostAddress aHost=addList.at(i);
            if(QAbstractSocket::IPv4Protocol==aHost.protocol())
            {
                localIP=aHost.toString();
                break;
            }
        }
    }
    return localIP;
}//这个函数中并没有socket

void MainWindow::on_actStart_triggered()
{
    QString IP=ui->comboBox->currentText();
    quint16 port=ui->spinBox->value();
    QHostAddress addr(IP);
    server->listen(addr,port);//在本机某个IP地址和端口上开始TCP监听，以等待TCP客户端的接入。
    ui->plainTextEdit->appendPlainText("**开始监听...");
    ui->plainTextEdit->appendPlainText("**服务器地址："+server->serverAddress().toString());
    ui->plainTextEdit->appendPlainText("**服务器端口："+QString::number(server->serverPort()));
    ui->actStart->setEnabled(false);
    ui->actStop->setEnabled(true);
    LabListen->setText("监听状态：正在监听");
    connect(server,SIGNAL(sendToMain(QString)),this,SLOT(receiveFromServer(QString)));
}

void MainWindow::on_actStop_triggered()
{
    if(server->isListening())
    {
        server->close();
        ui->actStart->setEnabled(true);
        ui->actStop->setEnabled(false);
        LabListen->setText("监听状态：已停止监听");
    }
}

void MainWindow::receiveFromServer(QString str)
{
    int mid=str.indexOf(',');
    QString member=str.mid(0,mid);
    QString fault=str.mid(mid+1,str.length()-mid-1);
    ui->plainTextEdit->appendPlainText("成员系统："+member);
    ui->plainTextEdit->appendPlainText("故障种类："+fault);
    QQuickItem *root=ui->view->rootObject();
    tran=root->findChild<transObj *>("tran");//不用new的原因是这个对象在qml中创建过了
    if(member.compare("RDC1")==0) tran->sendValToQml(1);
    else if(member.compare("左CCR")==0) tran->sendValToQml(2);
}


//非多线程新连接的客户端会把老客户端挤掉

void MainWindow::on_buttonY_clicked()
{
    QQuickItem *root=ui->view->rootObject();
    tran=root->findChild<transObj *>("tran");
    tran->sendValToQml(10);
}

void MainWindow::on_buttonX_clicked()
{
    QQuickItem *root=ui->view->rootObject();
    tran=root->findChild<transObj *>("tran");
    tran->sendValToQml(11);
}


void MainWindow::on_buttonLook_clicked()
{
    QQuickItem *root=ui->view->rootObject();
    tran=root->findChild<transObj *>("tran");
    tran->sendValToQml(12);
}

void MainWindow::on_elecButton_clicked()
{
    QQuickItem *root=ui->view->rootObject();
    tran=root->findChild<transObj *>("tran");
    tran->sendValToQml(13);
}
