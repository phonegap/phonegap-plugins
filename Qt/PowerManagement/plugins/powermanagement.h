#ifndef POWERMANAGEMENT_H
#define POWERMANAGEMENT_H

#include "../pgplugin.h"

#include <QSystemScreenSaver>

QTM_USE_NAMESPACE

class PowerManagement : public PGPlugin
{
    Q_OBJECT
public:
    explicit PowerManagement(QWebFrame *p_webFrame);

signals:

public slots:
    void release( int scId, int ecId );
    void acquire( int scId, int ecId );

private:
    QSystemScreenSaver *m_systemScreenSaver;
};

#endif // POWERMANAGEMENT_H
