/*
 *  Common.c
 *  Firewall
 *
 *  Created by Brian Olsen on 08/06/08.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include "Common.h"

const BASCommandSpec kMyCommandSet[] = {
    {
        kMyFirstCommand,          // commandName
        kMyFirstCommandRightName, // rightName
        "allow",                  // rightDefaultRule -- allow anyone
        NULL,                     // rightDescriptionKey -- no custom prompt
        NULL                      // userData
    },
    {
        kMySecondCommand,         // commandName
        kMySecondCommandRightName,// rightName
        "default",                // rightDefaultRule -- need admin creds
        NULL,                     // rightDescriptionKey -- no custom prompt
        NULL                      // userData
    },
    {   
        NULL,                     // the array is null terminated
        NULL, 
        NULL, 
        NULL, 
        NULL
    }
};
