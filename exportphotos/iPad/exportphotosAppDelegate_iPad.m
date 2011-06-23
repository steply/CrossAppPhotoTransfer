//
//  exportphotosAppDelegate_iPad.m
//  exportphotos
//
//  Created by james on 6/10/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import "exportphotosAppDelegate_iPad.h"
#import "ExportPhotoViewController_iPad.h"

@implementation exportphotosAppDelegate_iPad

- (void)dealloc
{
	[super dealloc];
}


#pragma mark Properties

- (ExportPhotoViewController *)controller {
    if ( ! _controller) {
        _controller = [[ExportPhotoViewController_iPad alloc] initWithNibName:@"ExportPhotoViewController" bundle:nil];
    }
    return _controller;
}


@end
