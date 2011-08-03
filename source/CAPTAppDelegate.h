//
//  CAPTAppDelegate.h
//  tape
//
//  Created by james on 6/14/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>

// General userInfo key
extern NSString const *CAPTActionKey;
extern NSString const *CAPTURLKey;

@interface CAPTAppDelegate : NSObject <UIApplicationDelegate> {
}

// Subclass should call super's implementation for these methods:
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;


// Called before processing the action.
- (void)willStartProcessingURLAction:(NSString *)action; 

// Called on succeed processing the necessary action. 
- (void)didSucceedProcessingURLActionWithUserInfo:(NSDictionary *)userInfo; 

// Execute this when your url processing is completed
- (void)notifyHandlerInMainThreadWithUserInfo:(NSDictionary *)userInfo; 

@end
