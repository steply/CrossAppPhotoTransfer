//
//  CAPTTransferPhotoTableViewController.m
//  tape
//
//  Created by james on 6/15/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import "CAPTTransferPhotoTableViewController.h"
#import "CAPTAppExportList.h"
#import "CAPTApp+TransferPhoto.h"
#import <objc/runtime.h>

@interface CAPTTransferPhotoTableViewController ()
- (id)initWithArray:(NSArray *)list image:(UIImage *)image meta:(NSDictionary *)metaDict;
@property (nonatomic, readonly) NSArray *list;
@end


#define APP_STORE_ALERT_TAG 10000
static char *appKey;

#import "UIImageView+WebCache.h"
#import "CAPTApp.h"


@implementation CAPTTransferPhotoTableViewController
@synthesize list = _list;

- (id)initWithImage:(UIImage *)image meta:(NSDictionary *)metaDict {
    if ((self == [self initWithStyle:UITableViewStylePlain])) {
        _image      = [image retain];
        _metaDict   = [metaDict retain];

        // Create a list [app1, app2, unavailableAppArray[]]
        CAPTAppExportList *exportList = [CAPTAppExportList sharedExportList];
        NSMutableArray *rootList = [[NSMutableArray alloc] initWithArray:exportList.listAvaliable];
        [rootList addObject:exportList.listUnavaliable];
        _list       = [[NSArray alloc] initWithArray:rootList];
        [rootList release];
    }
    return self;
}

- (id)initWithArray:(NSArray *)list image:(UIImage *)image meta:(NSDictionary *)metaDict {
    if ((self = [super initWithStyle:UITableViewStylePlain])) {
        _image      = [image retain];
        _metaDict   = [metaDict retain];
        _list       = [list retain];
    }
    return self;
}

- (void)dealloc
{
    [_list release];
    [_image release]; 
    [_metaDict release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 55;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[URLSchemeExportTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.minimumFontSize = 8;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumFontSize = 8;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    id row = [_list objectAtIndex:indexPath.row];
    if ([row isKindOfClass:[CAPTApp class]]) {
        CAPTApp *app = (CAPTApp *)row;
        cell.textLabel.text = app.name;
        cell.detailTextLabel.text = app.bio;
        cell.accessoryType = app.storeURL ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        [cell.imageView setImageWithURL:app.iconURL placeholderImage:[UIImage imageNamed:@"app_icon_placeholder.png"]];
    } else if ([row isKindOfClass:[NSArray class]]) {
        cell.textLabel.text = @"Apps Not Installed";
        cell.detailTextLabel.text = @"Download more apps with photos export.";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"gray_dash_40.png"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_list count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id row = [_list objectAtIndex:indexPath.row];
    
    if ([row isKindOfClass:[CAPTApp class]]) {
        CAPTApp *app = (CAPTApp *)row;
        if ([app isInstalled]) {
            CAPTApp *app = [self.list objectAtIndex:indexPath.row];
            [app transferPhotoWithImage:_image meta:_metaDict];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:app.name
                                                                message:[NSString stringWithFormat:@"Looks like you've not installed this application or you haven't update this application yet. Do you want to proceed to the App Store?"]
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"View", nil];
            alertView.tag = APP_STORE_ALERT_TAG;
            //        [alertView setValue:app.storeURL forKey:APP_STORE_URL];
            objc_setAssociatedObject(alertView, &appKey, app, OBJC_ASSOCIATION_RETAIN);
            [alertView show];
            [alertView release];
        }
    } else if ([row isKindOfClass:[NSArray class]]) {
        CAPTTransferPhotoTableViewController *controller = [[CAPTTransferPhotoTableViewController alloc] initWithArray:(NSArray *)row image:_image meta:_metaDict];
        controller.title = @"Not Installed";
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == APP_STORE_ALERT_TAG) {
        if (buttonIndex == 1) {
            CAPTApp *app = objc_getAssociatedObject(alertView, &appKey);
            NSLog(@"Opening: %@", [app.storeURL absoluteString]);
            [[UIApplication sharedApplication] openURL:app.storeURL];
        } else {
            // Cancelled
            NSLog(@"Cancelled");            
        }
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end


@implementation URLSchemeExportTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.bounds = (CGRect){CGPointZero, CGSizeMake(40, 40)};
}

@end
