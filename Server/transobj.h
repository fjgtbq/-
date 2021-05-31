#ifndef TRANSOBJ_H
#define TRANSOBJ_H
#include <QObject>
#include <QDebug>
class transObj : public QObject
{
    Q_OBJECT//Qt信号与槽机制
public:
    Q_INVOKABLE void sendValToQml(int val)
    {
        emit valFromCpp(val);
    }
signals:
    void valFromCpp(int val);
};

#endif // TRANSOBJ_H
