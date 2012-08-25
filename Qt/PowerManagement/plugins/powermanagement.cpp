#include "powermanagement.h"

PowerManagement::PowerManagement(QWebFrame *p_webFrame) :
    PGPlugin(p_webFrame)
{
    m_systemScreenSaver = new QSystemScreenSaver();
}

void PowerManagement::release( int scId, int ecId ) {
    m_systemScreenSaver->setScreenSaverInhibited(false);

    // Check if everything went fine
    if( !m_systemScreenSaver->screenSaverInhibited() ) {
        this->callback( scId, "" );
    }
    else {
        this->callback( ecId, "" );
    }
}

void PowerManagement::acquire( int scId, int ecId ) {
    m_systemScreenSaver->setScreenSaverInhibited(true);

    // Check if everything went fine
    if( m_systemScreenSaver->screenSaverInhibited() ) {
        this->callback( scId, "" );
    }
    else {
        this->callback( ecId, "" );
    }
}
