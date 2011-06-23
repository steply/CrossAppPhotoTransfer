//
//  CAPTApp.m
//  tape
//
//  Created by james on 16/06/2011.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import "CAPTApp.h"


@implementation CAPTApp
@synthesize jsonValue = _jsonValue;

+ (CAPTApp *)sampleAppForImportPhotos {
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"ImportPhotos", @"name",
                                @"importphotos", @"scheme",
                                @"Sample import app", @"bio",
                                nil];
    
    return [[[[self class] alloc] initWithDictionary:dictionary] autorelease];
}

- (CAPTApp *)initWithDictionary:(NSDictionary *)jsonValue {
    if ((self = [super init])) {
        _jsonValue = [jsonValue retain];
    }
    return self;
}

- (void)dealloc {
    [_jsonValue release];
    [super dealloc];
}

- (NSString *)description {
    return [self.jsonValue description];
}

- (BOOL)openURLWithPath:(NSString *)path {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", self.scheme, path]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    return NO;
}

#pragma mark Properties

- (NSString *)name {
    return [_jsonValue valueForKeyPath:@"name"];
}

- (NSString *)scheme {
    return [_jsonValue valueForKeyPath:@"scheme"];
}

- (NSURL *)iconURL {
    NSString *iconURLString = [_jsonValue valueForKeyPath:@"icon_url"];
    if (iconURLString) {
        return [NSURL URLWithString:iconURLString];
    } else {
        return nil;
    }
}

- (NSURL *)storeURL {
    NSString *storeURLString = [_jsonValue valueForKeyPath:@"store_url"];
    if (storeURLString) {
        return [NSURL URLWithString:storeURLString];
    } else {
        return nil;
    }
}

- (NSString *)bio {
    return [_jsonValue valueForKeyPath:@"bio"];
}

#pragma mark -

- (BOOL)isInstalled {
    NSString *urlString = [NSString stringWithFormat:@"%@://", self.scheme];
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]];
}

#pragma mark NSCoding

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.jsonValue forKey:@"jsonValue"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSDictionary *dict = [aDecoder decodeObjectForKey:@"jsonValue"];
    self = [[CAPTApp alloc] initWithDictionary:dict];
    return self;
}

@end
