//
//  exportphotosAppDelegate.h
//  exportphotos
//
//  Created by james on 6/10/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ExportPhotoViewController;

@interface exportphotosAppDelegate : NSObject <UIApplicationDelegate> {
    ExportPhotoViewController *_controller;
}
@property (nonatomic, readonly) ExportPhotoViewController *controller;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
