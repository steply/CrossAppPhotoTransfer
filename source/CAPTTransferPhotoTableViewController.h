//
//  CAPTTransferPhotoTableViewController.h
//  tape
//
//  Created by james on 6/15/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CAPTTransferPhotoTableViewController : UITableViewController {
    UIImage *_image;
    NSDictionary *_metaDict;
    NSArray *_list;
}

- (id)initWithImage:(UIImage *)image            // Required.
               meta:(NSDictionary *)metaDict;   // Optional. Highly recommended to be there. See readme for how to get the meta data from camera or photo library.

@end


@interface URLSchemeExportTableViewCell : UITableViewCell {
    
}
@end