//
//  CAPTAppDelegate+TransferPhoto.m
//  tape
//
//  Created by james on 17/06/2011.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import "CAPTAppDelegate+TransferPhoto.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "CAPTHandler+TransferPhoto.h"
#import "NSURL+CAPTURLHelper.h"


UIImage *fixImageWithOrientation(UIImage *image, UIImageOrientation orientation)
{
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);

    
    CGFloat scaleRatio = 1;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = orientation;
    switch(orient) {
            
            case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
            case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
            case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
            case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
            case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
            case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
            case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
            case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
            default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
        }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
        }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
        }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}


@implementation CAPTAppDelegate (TransferPhoto)

- (void)transfer_photo_urlhandler:(NSURL *)url {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *action = [url host];
//    NSParameterAssert([action isEqualToString:URLSchemeTransferPhotoAction]);
    
    NSLog(@"url :%@", url);
    NSString *pasteboardName = nil;
    pasteboardName = [[url capt_pathComponents] objectAtIndex:1];
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:pasteboardName create:YES]; // For iOS 3, we needed to set "YES" to the create property and believes the pasteboard is already there.
    if ( ! pasteboard) {
        NSLog(@"No pasteboard with name `%@` exists", pasteboardName);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Import photo error" message:[NSString stringWithFormat:@"No pasteboard with name `%@` exists", pasteboardName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    } else {
        
        UIImageOrientation orientation = UIImageOrientationUp;      // Default orientation
        
        // Get imageOrientation from query
        NSString *query = [url query];
        NSArray *components = [query componentsSeparatedByString:@"&"];
        int count = [components count];
        for (int i = 0; i < count; i++) {
            NSString *component = [components objectAtIndex:i];
            NSArray  *keyValue  = [component componentsSeparatedByString:@"="];
            NSString *key       = [keyValue objectAtIndex:0];
            NSString *value     = [keyValue objectAtIndex:1];
            if ([key isEqualToString:@"imageOrientation"]) {
                orientation = [value intValue];
            }
        }
        
        UIImage *image = [UIImage imageWithData:[pasteboard dataForPasteboardType:(NSString *)kUTTypeImage]];
        NSString *metaData = nil;
        NSDictionary *dict = nil;
        // Prevent crash when meta data dict is not avaliable
        if ([pasteboard containsPasteboardTypes:[NSArray arrayWithObject:(NSString *)kUTTypeText]]) {
            metaData = [NSString stringWithUTF8String:[(NSData *)[pasteboard valueForPasteboardType:(NSString *)kUTTypeText] bytes]];
            dict = [metaData propertyListFromStringsFileFormat];
        }
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@", pasteboardName] message:[NSString stringWithFormat:@"%d, %@, meta %@", [pasteboard numberOfItems], image, metaData] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alertView show];
//        [alertView release];
        
        if (image.imageOrientation != orientation) {
            if ([UIImage instancesRespondToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
                image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:orientation];
            } else {
                image = fixImageWithOrientation(image, orientation);    // For iOS 3.
            }
        }
        
        [UIPasteboard removePasteboardWithName:pasteboardName];

        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:url forKey:CAPTURLKey];
        [userInfo setObject:action forKey:CAPTActionKey];
        if (image) {
            [userInfo setObject:image forKey:CAPTTransferPhotoImageKey];
        }
        if (metaData) {
            [userInfo setObject:metaData forKey:CAPTTransferPhotoMetaKey];
        }
        
        [self notifyHandlerInMainThreadWithUserInfo:[NSDictionary dictionaryWithDictionary:userInfo]];
        [userInfo release];
    }
    
    
    [pool drain];
}

@end
