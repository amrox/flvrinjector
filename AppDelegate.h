//
//  AppDelegate.h
//  FLVrInjectr
//
//  Created by Andy Mroczkowski on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PreferencesController;

const NSInteger kOutputModeInPlace = 0;
const NSInteger kOutputModeNewFile = 1;

@interface AppDelegate : NSWindowController
{
	IBOutlet NSArrayController* flvPathsController;
	IBOutlet NSTableView* filesTableView;
	IBOutlet NSPopUpButton* chooseSaveLocationPopupButton;
	IBOutlet NSTextField* statusMessageLabel;

	IBOutlet PreferencesController* preferencesController;
	
	NSMutableArray* _recentSaveLocations;
	NSUInteger _recentSaveLocationsMax;
	
	NSOperationQueue *_opQueue;
	BOOL _isWorking;
}

@property (nonatomic, assign) BOOL shouldUseCreatorTag;
@property (nonatomic, retain) NSString* creatorTag;
@property (nonatomic, assign) BOOL shouldAddOnLastSecondEvent;
@property (nonatomic, assign) BOOL shouldOutputXML;

@property (nonatomic, assign) NSInteger outputMode;
@property (nonatomic, assign) NSInteger outputLocationMenuItemIndex;

@property (nonatomic, retain) NSMutableArray* recentSaveLocations;
@property (nonatomic, assign) NSUInteger recentSaveLocationsMax;

@property (readonly) BOOL isWorking;

- (IBAction) openFLVFiles:(id)sender;

- (IBAction) inject:(id)sender;

- (IBAction) chooseSaveLocation:(id)sender;

- (IBAction) showPreferencesWindow:(id)sender;

- (NSError *)injectForInputFile:(NSString *)inputPath outputFile:(NSString *)outputPath;

- (void) addNewRecentPath:(NSString *)path;
- (void) rebuildChooseSaveLocationMenu;
@end
