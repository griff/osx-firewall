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
    return noErr;
}

OSStatus DoMySecondCommand(
    AuthorizationRef            auth,
    const void *                userData,
    CFDictionaryRef             request,
    CFMutableDictionaryRef      response,
    aslclient                   asl,
    aslmsg                      aslMsg
) {
    return noErr;
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
