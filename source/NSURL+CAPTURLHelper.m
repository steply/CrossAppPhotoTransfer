//
//  NSURL+CAPTURLHelper.m
//  tape
//
//  Created by james on 6/22/11.
//  Copyright (c) 2011 Stepcase. All rights reserved.
//

#import "NSURL+CAPTURLHelper.h"


@implementation NSURL (CAPTURLHelper)

- (NSArray *)capt_pathComponents {
    if ([self respondsToSelector:@selector(pathComponents)]) {      // iOS 4.0+
        return [self pathComponents];
    } else {
        return [[self relativePath] componentsSeparatedByString:@"/"];
    }
}

@end
