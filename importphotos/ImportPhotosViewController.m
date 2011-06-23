//
//  ImportPhotosViewController.m
//  tape
//
//  Created by james on 6/20/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import "ImportPhotosViewController.h"


@implementation ImportPhotosViewController
@synthesize imageView, statusLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.imageView = nil;
    self.statusLabel = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.statusLabel.editable = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didSucceedProcessingURLActionWithUserInfo:(NSDictionary *)userInfo {
    if ([[userInfo objectForKey:CAPTActionKey] isEqual:CAPTTransferPhotoAction]) {
        // Check which action has performed before doing any parsing
        
        UIImage *image = [userInfo objectForKey:CAPTTransferPhotoImageKey];
        self.imageView.image = image;
    }
    self.statusLabel.text = [userInfo description];
}

- (void)willStartProcessingURLAction:(NSString *)action {
    self.statusLabel.text = @"Loading...";
}

@end
