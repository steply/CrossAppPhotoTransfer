//
//  CAPTApp.h
//  tape
//
//  Created by james on 16/06/2011.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CAPTApp : NSObject <NSCoding> {
    NSDictionary *_jsonValue;
}

@property (nonatomic, readonly) NSDictionary *jsonValue;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *scheme;
@property (nonatomic, readonly) NSURL    *iconURL;
@property (nonatomic, readonly) NSURL    *storeURL;
@property (nonatomic, readonly) NSString *bio;

+ (CAPTApp *)sampleAppForImportPhotos;
- (CAPTApp *)initWithDictionary:(NSDictionary *)jsonValue;
- (BOOL)isInstalled;
- (BOOL)openURLWithPath:(NSString *)path;

@end

#define kCAPTBundleName				@"CAPTResources.bundle"

UIImage *CAPTImageNamed(NSString *filename);