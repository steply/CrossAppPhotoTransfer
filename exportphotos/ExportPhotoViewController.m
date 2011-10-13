//
//  ExportPhotoViewController.m
//  Stepcase
//
//  Created by james on 6/10/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import "ExportPhotoViewController.h"
#import "CAPT.h"
#import "CAPTAppExportTestingList.h"

@interface ExportPhotoViewController ()
@property (nonatomic, retain) NSDictionary *metaData;
@end

@implementation ExportPhotoViewController
@synthesize metaData = _metaData;

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
    [_metaData release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context && [(NSObject *)context isEqual:self.list]) {
        if (self.list.state == NSURLConnectionStateConnecting) {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.reloadButton setCustomView:indicator];
            [indicator startAnimating];
            [indicator release];
        } else {
            [self.reloadButton setCustomView:nil];
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.title = @"Export Photo Sample";
    if ( ! _imageView.image) {
        _exportButton.enabled = NO;
        _sendToImportAppButton.enabled = NO;
    }
    
    NSLog(@"self.list %@", self.list.list);
    [self.list addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:self.list];
    [self.list getListFromServer];
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

- (void)openImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = sourceType;
    controller.delegate   = self;
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

#pragma mark User Actions

- (IBAction)cameraButtonDidPress:(id)sender {
    if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Library", nil];
        [actionSheet showInView:self.view];
        [actionSheet release];
    } else {
        [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (IBAction)exportButtonDidPress:(id)sender {
    CAPTTransferPhotoTableViewController *controller = [[CAPTTransferPhotoTableViewController alloc] initWithImage:_imageView.image meta:_metaData];
    controller.navigationItem.rightBarButtonItem = self.reloadButton;
    controller.title = @"Transfer to...";
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)sendToImportAppButtonDidPress:(id)sender {
    // Create the object reference to the sample importphotos app.
    CAPTApp *app = [CAPTApp sampleAppForImportPhotos];
    
    if ([app isInstalled]) {
        [app transferPhotoWithImage:_imageView.image meta:_metaData];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sample Import app not installed" message:@"Please choose and build the importphotos target" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == 1) {
        [self openImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    } else {
        // Cancel
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)dismissImagePicker {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (&UIImagePickerControllerMediaMetadata) {
        self.metaData = [info objectForKey:UIImagePickerControllerMediaMetadata];
    }
    _imageView.image = image;
    _exportButton.enabled = YES;
    _sendToImportAppButton.enabled = YES;
    [self dismissImagePicker];
}

#pragma mark Properties

- (CAPTAppExportList *)list {
    return [CAPTAppExportTestingList sharedExportList];
}

- (UIBarButtonItem *)reloadButton {
    if ( ! _reloadButton) {
        _reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self.list action:@selector(getListFromServer)];
    }
    return _reloadButton;
}

@end
