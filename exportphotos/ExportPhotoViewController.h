//
//  ExportPhotoViewController.h
//  Stepcase
//
//  Created by james on 6/10/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CAPTAppExportList;

@interface ExportPhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {

    IBOutlet UIImageView *_imageView;
    IBOutlet UIBarButtonItem *_cameraButton;
    IBOutlet UIBarButtonItem *_exportButton;
    IBOutlet UIBarButtonItem *_sendToImportAppButton;
    UIBarButtonItem          *_reloadButton;
    NSDictionary   *_metaData;
}

@property (nonatomic, readonly) CAPTAppExportList    *list;
@property (nonatomic, readonly) UIBarButtonItem *reloadButton;

- (IBAction)cameraButtonDidPress:(id)sender;
- (IBAction)exportButtonDidPress:(id)sender;
- (IBAction)sendToImportAppButtonDidPress:(id)sender;

@end