//
//  CAPTAppDelegate.m
//  tape
//
//  Created by james on 6/14/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import "CAPTAppDelegate.h"

// NB: Better not to change the string because once defined, modifying will break previous support
NSString const *CAPTActionKey             = @"URLSchemeActionKey";
NSString const *CAPTURLKey                = @"CAPTURLKey";

@implementation CAPTAppDelegate

- (BOOL)handleURL:(NSURL *)url {
    NSString *action = [url host];
    // Now only supports transfer_photo.
    if (action) {
        NSString *selectorString = [NSString stringWithFormat:@"%@_urlhandler:", action];
        SEL selector = NSSelectorFromString(selectorString);
        if ([self respondsToSelector:selector]) {
            [self willStartProcessingURLAction:action];
            [self performSelectorInBackground:selector withObject:url];
            return YES;
        } else {
            NSLog(@"Does not response to method: %@", selectorString);
        }
    }
    return NO;
}

// iOS 3.x
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if ( ! url) {
        return YES; // If no url, it's a clean launch, return YES
    }
    return [self handleURL:url];
}

// iOS 4.1 or below
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self handleURL:url];
}

// iOS 4.2 or above
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self handleURL:url];
}

- (void)notifyHandlerWithUserInfo:(NSDictionary *)dict {
    [self didSucceedProcessingURLActionWithUserInfo:dict];
}

- (void)notifyHandlerInMainThreadWithUserInfo:(NSDictionary *)userInfo {
    [self performSelectorOnMainThread:@selector(notifyHandlerWithUserInfo:) withObject:userInfo waitUntilDone:YES];
}

- (void)willStartProcessingURLAction:(NSString *)action { 
    // Do nothing. To be handled by subclass
}
    
- (void)didSucceedProcessingURLActionWithUserInfo:(NSDictionary *)userInfo {
    // Do nothing. To be handled by subclass
}

@end
