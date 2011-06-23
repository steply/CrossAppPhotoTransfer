//
//  ExportPhotoViewController_iPad.m
//  tape
//
//  Created by james on 6/21/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import "ExportPhotoViewController_iPad.h"


@implementation ExportPhotoViewController_iPad

- (void)openImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = sourceType;
    controller.delegate   = self;

    [self popControllerWithContentViewController:controller];
    [controller release];
    [self.popController presentPopoverFromBarButtonItem:_cameraButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (UIPopoverController *)popControllerWithContentViewController:(UIViewController *)controller {
    [_popController release]; _popController = nil;
    if ( ! _popController) {
        _popController = [[UIPopoverController alloc] initWithContentViewController:controller];
    }
    return _popController;
}

- (UIPopoverController *)popController {
    return _popController;
}

#pragma mark UIImageViewControllerDelegate

- (void)dismissImagePicker {
    [self.popController dismissPopoverAnimated:YES];
}

@end
