//
//  CAPTAppExportList.m
//  tape
//
//  Created by james on 6/13/11.
//  Copyright 2011 Stepcase. All rights reserved.
//

#import "CAPTAppExportList.h"
#import "JSON.h"
#import "CAPTApp.h"
#import "UIImageView+WebCache.h"

@interface CAPTAppExportList ()
- (void)setState:(NSURLConnectionState)state;
- (void)setList:(NSArray *)list;
- (NSArray *)getListFromCache;  // The cached returned from last sucessful download
- (NSArray *)getListFromDisk;   // The first time cache
@property (nonatomic, readonly) NSURLRequest    *request;
@property (nonatomic, readonly) NSURLConnection *connection;
@property (nonatomic, readonly) NSMutableData   *data;
@end

#define USER_DEFAULTS_LIST_KEY @"ExportPhotoList"

@implementation CAPTAppExportList
@synthesize state = _state;

static CAPTAppExportList *_sharedInstance;

+ (CAPTAppExportList *)sharedExportList
{
	@synchronized(self) {
		
        if (_sharedInstance == nil) {
            _sharedInstance = [[self alloc] init];
        }
    }
    return _sharedInstance;
}


+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_sharedInstance == nil) {
			
            _sharedInstance = [super allocWithZone:zone];			
            return _sharedInstance;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}

- (id)init {
    if ((self = [super init])) {
        if ( ! _list) {
            _list = [self getListFromCache];
            NSLog(@"Getting list from last successful download %@", _list);
        }
        // If not able to get list from last successful downloads, get from first time cache
        if ( ! _list) {
            _list = [self getListFromDisk];
            NSLog(@"Getting list from first time cache %@", _list);
        }
    }
    return self;
}


#pragma mark Life Cycle

- (void)clearCache {
    [_list release];            _list = nil;
    [_listAvaliable release];   _listAvaliable = nil;
    [_listUnavaliable release]; _listUnavaliable = nil;
}

- (void)getListFromServer {
    self.state = NSURLConnectionStateConnecting;
    [_data release];            _data = nil;
    [_connection release];      _connection = nil;
    [self.connection start];
}

- (void)dealloc {
    [_listAvaliable release];
    [_listUnavaliable release];
    [_list release];
    [_data release];
    [_connection release];
    [_request release];
    [super dealloc];
}

#pragma mark Properties

- (NSURLConnection *)connection {
    if ( ! _connection) {
        _connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
        [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _connection;
}

- (NSURLRequest *)request {
    if ( ! _request) {
        _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.capt.me/1/transfer_apps.json"]];
    }
    return _request;
}

- (NSMutableData *)data {
    if ( ! _data) {
        _data = [[NSMutableData alloc] init];
    }
    return _data;
}

- (NSArray *)list {
    return _list;
}

- (void)setList:(NSArray *)list {
    if (_list != list) {
        [_list release];
        _list = [list copy];
    }
}

- (NSArray *)listAvaliable {
    if ( ! _listAvaliable) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isInstalled = TRUE"];
        _listAvaliable = [[self.list filteredArrayUsingPredicate:predicate] retain];
    }
    return _listAvaliable;
}


- (NSArray *)listUnavaliable {
    if ( ! _listUnavaliable) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isInstalled = FALSE"];
        _listUnavaliable = [[self.list filteredArrayUsingPredicate:predicate] retain];
    }
    return _listUnavaliable;
}

- (void)setState:(NSURLConnectionState)state {
    _state = state;
}

- (NSArray *)getListFromCache {
    if ( ! _list) {
        @try {
            // Incase the offline cache is totally different
            id data = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULTS_LIST_KEY];
            NSArray *list = nil;
            if ([data isKindOfClass:[NSData class]]) {
                list = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            } else if ([data isKindOfClass:[NSArray class]]) {
                list = data;
            }
            if (list) {
                self.list = list;
            }
        }
        @catch (NSException *exception) {
        }
    }
    return _list;
}

- (NSArray *)getListFromDisk {
    if ( ! _list) {
        @try {
            // Incase the offline cache is totally different
            NSString *defaultListPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kCAPTBundleName] stringByAppendingPathComponent:@"default_transfer_apps.json"];
            NSError *error = nil;
            NSString *data = [[NSString alloc] initWithContentsOfFile:defaultListPath encoding:NSUTF8StringEncoding error:&error];
            NSAssert( ! error, @"unable to read or locate default_transfer_apps.json");

            
            NSMutableArray *list = [[NSMutableArray alloc] init];
            for (NSDictionary *appDict in [data JSONValue]) {
                CAPTApp *app = [[CAPTApp alloc] initWithDictionary:appDict];
                [list addObject:app];
                [app release];
            }
            _list = [[NSArray alloc] initWithArray:list];
            [list release];
        }
        @catch (NSException *exception) {
        }
    }
    return _list;
}

#pragma mark NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self clearCache];
    
    // Parse data
    NSString *json = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [json JSONValue];
    NSMutableArray *appList = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in jsonArray) {
        CAPTApp *app = [[CAPTApp alloc] initWithDictionary:dict];
        [appList addObject:app];
        [app release];
    }
    [json release];
    _list = appList;

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.list];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:USER_DEFAULTS_LIST_KEY];
    NSLog(@"Finished Loading! %@", self.list);
    self.state = NSURLConnectionStateIdle;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed to download export list.");
    NSLog(@"%@", [error description]);
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Export list download failed." message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
//    [alertView release];
    self.state = NSURLConnectionStateIdle;
}

@end


#define SECTION_AVALIABLE 0
#define SECTION_UNAVALIABLE 1

@implementation CAPTAppExportList (UITableView)

- (NSString *)schemeAtIndexPath:(NSIndexPath *)indexPath {
    CAPTApp *app = [self appAtIndexPath:indexPath];
    return app.scheme;
}

- (CAPTApp *)appAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_AVALIABLE:
            return [self.listAvaliable objectAtIndex:indexPath.row];
            break;
        case SECTION_UNAVALIABLE:
            return [self.listUnavaliable objectAtIndex:indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SECTION_AVALIABLE:
            return [self.listAvaliable count];
            break;
        case SECTION_UNAVALIABLE:
            return [self.listUnavaliable count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SECTION_AVALIABLE:
            return @"Avaliable";
            break;
        case SECTION_UNAVALIABLE:
            return @"Unavaliable";
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.detailTextLabel.minimumFontSize = 8;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumFontSize = 8;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    // Configure the cell...
    CAPTApp *app = [self appAtIndexPath:indexPath];
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.bio;
    cell.accessoryType = app.storeURL ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    [cell.imageView setImageWithURL:app.iconURL placeholderImage:[UIImage imageNamed:@"app_icon_placeholder.png"]];
    
    return cell;
}

@end
