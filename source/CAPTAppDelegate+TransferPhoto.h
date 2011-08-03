//
//  CAPTAppDelegate+TransferPhoto.h
//  tape
//
//  Created by james on 17/06/2011.
//  Copyright 2011 Stepcase. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CAPTAppDelegate.h"

// NB: Better not to change the string because once defined, modifying will break previous support
#define CAPTTransferPhotoAction   @"transfer_photo"
#define CAPTTransferPhotoImageKey @"URLSchemeTransferPhotoImageKey"
#define CAPTTransferPhotoMetaKey  @"URLSchemeTransferPhotoMetaKey"

@interface CAPTAppDelegate (TransferPhoto)

- (void)transfer_photo_urlhandler:(NSURL *)url;

@end

