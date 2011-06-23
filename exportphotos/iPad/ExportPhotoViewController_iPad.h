//
//  ExportPhotoViewController_iPad.h
//  tape
//
//  Created by james on 6/21/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExportPhotoViewController.h"

@interface ExportPhotoViewController_iPad : ExportPhotoViewController <UIPopoverControllerDelegate> {
    UIPopoverController *_popController;
}

@property (nonatomic, readonly) UIPopoverController *popController;
- (UIPopoverController *)popControllerWithContentViewController:(UIViewController *)controller;

@end
