#import <Cocoa/Cocoa.h>

#ifndef DevLog
#ifdef DEBUG
    #define DevLog(...)     NSLog(__VA_ARGS__)
#else
    #define DevLog(...)     do {} while(0)
#endif
#endif
