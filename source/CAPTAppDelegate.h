//
//  CAPTAppDelegate.h
//  tape
//
//  Created by james on 6/14/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPTHandlerDelegate.h"

@protocol CAPTHandlerDelegate;

@interface CAPTAppDelegate : NSObject <UIApplicationDelegate> {
    @private
    id <CAPTHandlerDelegate> _delegate;
}

@property (nonatomic, readonly) id <CAPTHandlerDelegate> delegate;
- (void)notifyHandlerInMainThreadWithUserInfo:(NSDictionary *)userInfo; // Execute this when your url processing is completed
@end
