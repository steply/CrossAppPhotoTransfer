//
//  CAPTAppExportTestingList.m
//  CrossAppPhotoTransfer
//
//  Created by james on 10/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CAPTAppExportTestingList.h"

@implementation CAPTAppExportTestingList

- (NSURLRequest *)request {
    if ( ! _request) {
        _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.capt.me/testing/transfer_apps.json"]];
    }
    return _request;
}

@end
