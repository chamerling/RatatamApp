//
//  UserPreferences.h
//  QuickHub
//
//  Created by Christophe Hamerling on 01/12/11.
//  Copyright 2011 christophehamerling.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MASPreferencesViewController.h"
#import "InstagramFetcher.h"

@interface UserPreferences : NSViewController<MASPreferencesViewController> {
    
    NSButton *accessButton;
    NSTextField *firstName;
    NSTextField *lastName;
    NSImageView *avatar;
    NSProgressIndicator *progressIndicator;
    
    InstagramFetcher *fetcher;
}
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
@property (assign) IBOutlet NSImageView *avatar;
@property (assign) IBOutlet NSTextField *firstName;
@property (assign) IBOutlet NSTextField *lastName;
@property (assign) IBOutlet NSButton *accessButton;

@property (assign) InstagramFetcher *fetcher;

- (IBAction)accessAction:(id)sender;

@end
