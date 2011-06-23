//
//  CAPTHandlerDelegate.h
//  tape
//
//  Created by james on 6/14/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <Foundation/Foundation.h>

// General userInfo key
extern NSString const *CAPTActionKey;
extern NSString const *CAPTURLKey;

@protocol CAPTHandlerDelegate <NSObject>
- (void)willStartProcessingURLAction:(NSString *)action;                        // Called before processing the action.
- (void)didSucceedProcessingURLActionWithUserInfo:(NSDictionary *)userInfo;     // Called on succeed processing the necessary action. 
@end