//
//  CAPTApp+TransferPhoto.m
//  tape
//
//  Created by james on 16/06/2011.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import "CAPTApp+TransferPhoto.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "CAPTHandler+TransferPhoto.h"

@interface CAPTApp (TransferPhotoPrivate)

- (NSURL *)transferPhotoURLWithPasteboardName:(NSString *)pasteboardName
                             imageOrientation:(UIImageOrientation)orientation;
@end

@implementation CAPTApp (TransferPhoto)

- (NSURL *)transferPhotoURLWithPasteboardName:(NSString *)pasteboardName imageOrientation:(UIImageOrientation)orientation {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@/%@?imageOrientation=%d", self.scheme, CAPTTransferPhotoAction, pasteboardName, orientation]];
    return url;
}


#pragma mark Exporting

- (void)transferPhotoWithImage:(UIImage *)image meta:(NSDictionary *)metaDict {
    NSAssert(image, @"SCExportListTransferPhotoError: image should not be nil");
    if ([self isInstalled]) {
        UIPasteboard *pasteboard = [UIPasteboard pasteboardWithUniqueName];   // Generate a new pasteboard with unique name
        pasteboard.persistent = YES;    // For iOS 3. The source app will quit and we needed to set the pasteboard to persistent

        NSURL *url = [self transferPhotoURLWithPasteboardName:pasteboard.name imageOrientation:image.imageOrientation];
        NSLog(@"Opening %@", url);

        if ( ! metaDict) {
            metaDict = [NSDictionary dictionary];
        }
        NSDictionary *imageDict = [NSDictionary dictionaryWithObjectsAndKeys:image, kUTTypeImage, [metaDict descriptionInStringsFileFormat], kUTTypeText, nil];
        [pasteboard setItems:[NSArray arrayWithObjects:imageDict, nil]];
        NSLog(@"imageDict %@", imageDict);
        [[UIApplication sharedApplication] openURL:url];

    } else {
        NSLog(@"Application not installed");
    }
}

@end
