//
//  ImportPhotosViewController.h
//  tape
//
//  Created by james on 6/20/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CAPT.h"

@interface ImportPhotosViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITextView  *statusLabel;

- (void)didSucceedProcessingURLActionWithUserInfo:(NSDictionary *)userInfo;
- (void)willStartProcessingURLAction:(NSString *)action;

@end
