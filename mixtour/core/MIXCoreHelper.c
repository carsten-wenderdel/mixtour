//
//  MIXCoreHelper.c
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-20.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#include <stdio.h>


/**
 returns "1" for i>0, "-1" for i<0, "0" for x==0;
 There's a unit test for it in this project.
 */
int signum (int i) {
    
    return (i > 0) - (i < 0);
}
