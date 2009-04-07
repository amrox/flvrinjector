//
//  AppDelegate.h
//  FLVrInjectr
//
//  Created by Andy Mroczkowski on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PreferencesController;

//typedef enum
//{
//	kOutputModeInPlace = 0,
//	kOutputModeNewFile = 1,
//} OutputMode;

const NSInteger kOutputModeInPlace = 0;
const NSInteger kOutputModeNewFile = 1;


@interface AppDelegate : NSWindowController
{
	IBOutlet NSArrayController* flvPathsController;
	IBOutlet NSTableView* filesTableView;
	IBOutlet NSPopUpButton* chooseSaveLocationPopupButton;

	IBOutlet PreferencesController* preferencesController;
	
//	BOOL _shouldUseCreatorTag;
//	NSString* _creatorTag;
//	BOOL _shouldAddOnLastSecondEvent;
//	BOOL _shouldOutputXML;
	
//	OutputMode _outputMode;
	
	NSMutableArray* _recentSaveLocations;
	NSUInteger _recentSaveLocationsMax;
}

@property (nonatomic, assign) BOOL shouldUseCreatorTag;
@property (nonatomic, retain) NSString* creatorTag;
@property (nonatomic, assign) BOOL shouldAddOnLastSecondEvent;
@property (nonatomic, assign) BOOL shouldOutputXML;

@property (nonatomic, assign) NSInteger outputMode;
@property (nonatomic, assign) NSInteger outputLocationMenuItemIndex;

@property (nonatomic, retain) NSMutableArray* recentSaveLocations;
@property (nonatomic, assign) NSUInteger recentSaveLocationsMax;

- (IBAction) openFLVFiles:(id)sender;

- (IBAction) inject:(id)sender;

- (IBAction) chooseSaveLocation:(id)sender;

- (IBAction) showPreferencesWindow:(id)sender;

- (NSError *)injectForInputFile:(NSString *)inputPath outputFile:(NSString *)outputPath;

- (void) addNewRecentPath:(NSString *)path;
- (void) rebuildChooseSaveLocationMenu;
@end
