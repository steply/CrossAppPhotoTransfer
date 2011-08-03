//
//  CAPTApp+TransferPhoto.h
//  tape
//
//  Created by james on 16/06/2011.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPTApp.h"

// NB: Better not to change the string because once defined, modifying will break previous support
#define CAPTTransferPhotoAction   @"transfer_photo"
#define CAPTTransferPhotoImageKey @"URLSchemeTransferPhotoImageKey"
#define CAPTTransferPhotoMetaKey  @"URLSchemeTransferPhotoMetaKey"

@interface CAPTApp (TransferPhoto)

- (void)transferPhotoWithImage:(UIImage *)image             // Required
                          meta:(NSDictionary *)metaDict;    // Optional

@end
