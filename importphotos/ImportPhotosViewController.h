//
//  ImportPhotosViewController.h
//  tape
//
//  Created by james on 6/20/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPTHandler+TransferPhoto.h"
#import "CAPTHandlerDelegate.h"

@interface ImportPhotosViewController : UIViewController <CAPTHandlerDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITextView  *statusLabel;

@end
