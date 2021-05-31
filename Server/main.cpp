#include "mainwindow.h"
#include "transobj.h"
#include <QApplication>
#include <QtQml>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    qmlRegisterType<transObj>("an.qml.TransObj",1,0,"TransObj");//包名，版本号，元素名
    MainWindow w;
    w.show();
    return a.exec();
}
