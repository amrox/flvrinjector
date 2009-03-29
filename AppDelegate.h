//
//  AppDelegate.h
//  FLVrInjectr
//
//  Created by Andy Mroczkowski on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSWindowController
{
	IBOutlet NSArrayController* flvPathsController;
	IBOutlet NSMatrix* saveOptionMatrix;
	IBOutlet NSTableView* filesTableView;
	
//	BOOL _shouldUseCreatorTag;
//	NSString* _creatorTag;
//	BOOL _shouldAddOnLastSecondEvent;
//	BOOL _shouldOutputXML;
	
	int _saveMode;
}

@property (nonatomic, assign) BOOL shouldUseCreatorTag;
@property (nonatomic, retain) NSString* creatorTag;
@property (nonatomic, assign) BOOL shouldAddOnLastSecondEvent;
@property (nonatomic, assign) BOOL shouldOutputXML;

@property (nonatomic, assign) int saveMode;

- (IBAction) openFLVFiles:(id)sender;

- (IBAction) go:(id)sender;

@end
