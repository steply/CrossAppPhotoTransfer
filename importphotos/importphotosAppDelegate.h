//
//  importphotosAppDelegate.h
//  importphotos
//
//  Created by james on 6/20/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPT.h"

@class ImportPhotosViewController;

@interface importphotosAppDelegate : CAPTAppDelegate <UIApplicationDelegate> {
    ImportPhotosViewController *_controller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
