//
//  DevUtils.h
//  TwitterPlane
//
//  Created by kazuyuki takahashi on 09/12/16.
//  Copyright 2009 by invisibledesigner.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//DEBUG時のみ有効なNSLog
#ifndef DevLog
#ifdef DEBUG
    #define DevLog(...)     NSLog(__VA_ARGS__)
#else
    #define DevLog(...)     do {} while(0)
#endif
#endif
