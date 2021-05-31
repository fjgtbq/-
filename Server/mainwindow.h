#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTcpSocket>
#include <QTcpServer>
#include <QLabel>
#include <QHostInfo>
#include <QThread>
#include "tcpsocket.h"
class tcpServer;
namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
private:
    QLabel *LabListen;
    tcpServer * server;
    QString getLocalIP();
    transObj *tran;

public:
    explicit MainWindow(QWidget *parent = nullptr);//explicit只能修饰只有一个参数的构造函数，表明
    //该构造函数是显式的。
    ~MainWindow();

signals:
    void import(Ui::MainWindow *);
private slots:
    void on_actStart_triggered();

    void on_actStop_triggered();
    void receiveFromServer(QString str);


    void on_buttonY_clicked();

    void on_buttonX_clicked();

    void on_buttonLook_clicked();

    void on_elecButton_clicked();

private:
    Ui::MainWindow *ui;//Ui只是一个命名空间，包含类MainWindow,详见12行
};

#endif // MAINWINDOW_H
