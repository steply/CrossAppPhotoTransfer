//
//  CAPTAppExportList.h
//  tape
//
//  Created by james on 6/13/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAPTApp;

typedef enum {
    NSURLConnectionStateIdle,
    NSURLConnectionStateConnecting
} NSURLConnectionState;

@interface CAPTAppExportList : NSObject {
    NSURLConnection *_connection;
    NSURLRequest    *_request;
    NSMutableData   *_data;
    NSArray         *_list;
    NSArray         *_listAvaliable;
    NSArray         *_listUnavaliable;
    NSURLConnectionState _state;
}

@property (nonatomic, readonly) NSArray         *list;              // The full list of apps.
@property (nonatomic, readonly) NSArray         *listAvaliable;     // The filtered list of apps that's avaliable for export
@property (nonatomic, readonly) NSArray         *listUnavaliable;   // The filtered list of apps that's not avaliable for export
@property (nonatomic, readonly) NSURLConnectionState state;         // KVO compliant. You can listen to this state changes and update the UI

+ (CAPTAppExportList *)sharedExportList;
- (void)getListFromServer;                                          // Update the list through the network

@end



@interface CAPTAppExportList (UITableView) <UITableViewDataSource>

// Return the scheme of the target indexPath.
- (NSString *)schemeAtIndexPath:(NSIndexPath *)indexPath;

// Return the app of the specific indexPath
- (CAPTApp *)appAtIndexPath:(NSIndexPath *)indexPath;

@end