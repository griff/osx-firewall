/*
 *  main.c
 *  Firewall
 *
 *  Created by Brian Olsen on 08/06/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */
 
#include "Common.h"

OSStatus DoMyFirstCommand(
    AuthorizationRef            auth,
    const void *                userData,
    CFDictionaryRef             request,
    CFMutableDictionaryRef      response,
    aslclient                   asl,
    aslmsg                      aslMsg
) {
    return 0;
}

OSStatus DoMySecondCommand(
    AuthorizationRef            auth,
    const void *                userData,
    CFDictionaryRef             request,
    CFMutableDictionaryRef      response,
    aslclient                   asl,
    aslmsg                      aslMsg
) {
    return 0;
}

static const BASCommandProc kMyCommandProcs[] = {
    DoMyFirstCommand,
    DoMySecondCommand,
    NULL
};

int main(int argc, char **argv)
{
    return BASHelperToolMain(kMyCommandSet, kMyCommandProcs);
}
