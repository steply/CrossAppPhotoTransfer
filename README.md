CrossAppPhotoTransfer
=====================
version 1.0

Abstract
--------
This is an open source library for cross app photo transfer in iOS. 
It enables:

- Photos to be sent to your app by any app using this library.
- Photos to be sent to any scheme using this library.
- Automatically updates the list of schemes that photos can be transferred to and from without submitting a new update.
- Uses the custom URL Scheme and UIPasteboard framework to copy and paste photos across different apps. 

What’s New (1.0)
----------------

- Exporting your photos through custom URL Scheme and the UIPasteboard
- Retaining photo meta data while transfering photo between apps

CrossAppPhotoTransfer Library Quick Start Guide
===============================================

The requirements needed to integrate the CAPT library into your app on iOS are:

- XCode version 3.2.5.
- Build with Base SDK of 3.0 or newer.
- The following extra frameworks should be included in your link step: (do this by right clicking on your project and selecting Add->Existing Frameworks...)
 - MobileCoreServices

If you specify a deployment target older than the 4.0, the following frameworks
should use "weak linking":

- UIKit

The “Export” function requires two open source projects:

- [SBJSON-library][]
- [SDWebImage][]

They are already specified in the .gitmodules. and you can checkout by running the commands:

	$ git submodules init
	$ git submodules update

After all, you just drag everything (including the CAPTResources.bundle) in the source folder into your project and #import "CAPT.h" header file to get started.

How To Export Photos
=
Initializing the URLExportList
Open up your applicationDelegate.m or rootViewController.m. You will need Internet access to retrieve the list of available schemes that use this library. 

	#pragma mark RootViewController.m
	#import "CAPT.h"

	// e.g. call [self updateList] on viewDidLoad/appliationDidLaunch
	-(void)updateList {
		CAPTAppExportList *list = [CAPTAppExportList sharedExportList];
		[list getListFromServer];  // Update the list from server, result will be stored in cache
	}

Export your photo
-
To export your photo to another app. We use  CAPTTransferPhotoTableViewController to show the list of apps. Open your viewController.m.

	#pragma mark ViewController.m
	#import "CAPT.h"

	// metaDict is highly recommended to be passed here. The dictionary contains Geo location and other information taken from the camera. See Additional > Retrieving Photo Exif.
	- (void)exportImage:(UIImage *)image			// Required
			       meta:(NSDictionary *)metaDict	// Optional
	{
		CAPTAppExportList *exportList = [CAPTAppExportList sharedExportList];
		NSArray *appList    = exportList.list;
		if ( ! appList) {
			NSLog(@"No app list has been downloaded yet");
			return;
		}
		if ( ! image) {
			NSLog(@"No images!");
			return;
		}

		// Present the table view controller to show the list
		CAPTTransferPhotoTableViewController *controller = [[CAPTTransferPhotoTableViewController alloc] initWithImage:image meta:metaDict];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}

How to import Photos
Configure your app-info.plist
Setup your app-info.plist to let iOS know which URL schemes your app can handle. Replace the necessary information with your own app’s info. Below is a sample of our Labelbox app.

[![](http://capt.me/images/capt/screen_shot_1.png)](http://capt.me/images/capt/screen_shot_1.png)

Configure your application delegate
-
Open up your applicationDelegate.h. Extend your delegate from NSObject to CAPTAppDelegate. This super class auto handles the URL register work for you.

	#import "CAPT.h"

	@interface AppDelegate : CAPTAppDelegate <UIApplicationDelegate> {
	}
	@end


	#pragma mark AppDelegate.m
	#import "CAPTHandlerDelegate.h"

	@implementation AppDelegate

	/* 
	// If your app supports iOS 3, you needed to modify - [AppDelegate application:didFinishLaunchWithOptions]
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

		// Return value of [super application:didFinishLaunchWithOptions] instead of default YES on iOS 3
		return [super application:application:application didFinishLaunchingWithOptions:launchOptions];
	}
	*/

	#pragma mark CAPTAppDelegate
	// Basically should be your root view controller or a singleton object which never releases.
	- (void)willStartProcessingURLAction:(NSString *)action {
		[self.controller willStartProcessingURLAction:action];
	}

	- (void)didSucceedProcessingURLActionWithUserInfo:(NSDictionary *)userInfo {
		[self.controller didSucceedProcessingURLActionWithUserInfo:userInfo];
	}

	@end

Configure your rootViewController
-
Open up your RootViewController.h and .m.

	#pragma mark RootViewController.h

	@interface RootViewController : UIViewController <CAPTHandlerDelegate> {
	}

	// The methods you would call CAPT in your app delegate
	- (void)willStartProcessingURLAction:(NSString *)action;
	- (void)didSucceedProcessingURLActionWithUserInfo:(NSDictionary *)userInfo;

	@end


	#pragma mark RootViewController.m
	#import "CAPT.h"

	@implementation RootViewController
	- (void)willStartProcessingURLAction:(NSString *)action {
		NSLog(@"RootViewController will starts processing url action: %@", action);
	// Display loading status here... 
	}

	- (void)didSucceedProcessingURLActionWithUserInfo:(NSDictionary *)userInfo {

	NSString *action = [userInfo objectForKey:CAPTActionKey];
	NSLog(@"didSucceedProcessingURLAction: %@", action);

	// Depends on your action. Currently only supports transfer_photo
		UIImage *image = [userInfo objectForKey:CAPTTransferPhotoImageKey];
		NSDictionary *dict = [userInfo objectForKey:CAPTTransferPhotoMetaKey];

		// Updates your UI to hides your loading indication

		// That’s it. Use your meta data and image here!
	}

	@end


Additional
=
Retrieving Photo Exif
-
UIImage doesn’t contain meta data or Geo-location by default. It’s highly recommended to retain meta data while transferring images across apps.
	// Retrieving Photo exif example for upload

	- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
		UIImage *image = [info objectForKey:UIImagePickerControllerMediaMetaData];

		// iOS4 only. If picker.sourceType is from UIImagePickerSourceTypeCamera and >= iOS4, this api could be able to get the Exif dictionary.
		// For images that loads from library, you will needed AssetsLibrary framework which will not be covered here at this moment.
		NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediadata];
	
		// Use your image and meta data here...
	}



Extending export functions
-
The library provides a handy helper that lets you open urls easily. e.g for opening a target URL for the first installed app with path [scheme]://startpage/1

	- (void)startPage {
		CAPTAppExportList *app = [[CAPTAppExportList sharedExportList].listAvailable objectAtIndex:0];
		[app openURLWithPath:@"startpage/1"];
		// That’s it!
	}

For more complicated exporting situations, you may want to look at the CAPTApp+TransferPhoto category.



Extending import functions
=
If you want to add more actions to your application, here are some recommended practices to extend your handling behaviour.

Lets take an example that you want to gracefully handle the URL for the above example - [scheme]://startpage/1

Simply create a new method inside your appdelegate.m with the following pattern

	SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@_urlhandler:", action]);

Your selector will be executed in a background thread and while it finishes, you should execute [self notifyHandlerInMainThreadWithUserInfo:dict]; in order to let your handler delegate know your process has been completed. See example.


	#pragma mark AppDelegate.m
	#import "CAPT.h"
	#import "YourRootViewController.h"

	// Initialize your own userInfo key here
	@implementation AppDelegate

	- (void)startpage_urlhandler:(NSURL *)url {
		// Your selector is being executed in a background thread, so you needed an autorelease pool here to prevent those warnings.
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];


		// Do all kinds of complex processing here...
		NSString *page = [[url pathComponents] objectAtIndex:1];

		// After you finish processing, use the helper method to notify our delegate in main thread.
		NSString *action = [url host];	// host is our "action"
		NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
										action, CAPTActionKey,
										page, YOUR_PAGE_USERINFO_KEY,  // Define key in YourRootViewController.h
	nil];
		[self notifyHandlerInMainThreadWithUserInfo:userInfo];
		[userInfo release];

		// Drain your pool
		[pool drain];
	}

	@end

For a fully reusable import and export handling pattern, it is highly recommended to look at the following sources files.

	source\
		*+TransferPhoto.h
		*+TransferPhoto.m


You can still alter the original handling behaviour in the app delegate, just call super for the URL handling methods. 

	#pragma mark AppDelegate.m
	#import "CAPT.h"

	@implementation AppDelegate

	// If you still wants CAPTAppDelegate execute default actions for you, remember to call super.

	// iOS 4.1 or below
	- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

		BOOL handled = [super application:application handleOpenURL:url];

		// Your own code here...
		// handled = <your result>;
		return handled;
	}

	// iOS 4.2 or above
	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

		BOOL handled = [super application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

		// Your own code here...
		// handled = <your result>;
		return handled;
	}


	@end



[SDWebImage]: https://github.com/steply/SDWebImage
[SBJSON-library]: https://github.com/steply/SBJSON-library
