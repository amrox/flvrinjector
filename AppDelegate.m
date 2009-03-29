//
//  AppDelegate.m
//  FLVrInjectr
//
//  Created by Andy Mroczkowski on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "YamdiRunner.h"

@implementation AppDelegate

//@synthesize shouldUseCreatorTag = _shouldUseCreatorTag;
//@synthesize creatorTag = _creatorTag;
//@synthesize shouldAddOnLastSecondEvent = _shouldAddOnLastSecondEvent;
//@synthesize shouldOutputXML = _shouldOutputXML;
@synthesize saveMode = _saveMode;

+ (void)initialize
{
	// -- Initialize Applications Defaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *appDefaults = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppDefaults"
																										   ofType:@"plist"]];	
	[defaults registerDefaults:appDefaults];
}


- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
//	self.shouldUseCreatorTag = NO;
//	self.creatorTag = @"";
//	self.shouldAddOnLastSecondEvent = NO;
//	self.shouldOutputXML = NO;
	self.saveMode = 1;
	[saveOptionMatrix setEnabled:NO];
}


- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
	if( [[[filename pathExtension] lowercaseString] isEqualToString:@"flv"] )
	{
		[[self window] makeKeyAndOrderFront:self];
		[flvPathsController addObject:filename];
		return YES;
	}
	return NO;
}


- (void) awakeFromNib
{
	//	[filesTableView setDraggingSourceOperationMask:NSDragOperationNone forLocal:YES];
	//	[filesTableView setDraggingSourceOperationMask:NSDragOperationNone forLocal:NO];
    [filesTableView registerForDraggedTypes:
	 [NSArray arrayWithObject:NSFilenamesPboardType]];	
}


- (IBAction) openFLVFiles:(id)sender
{
	NSOpenPanel* openPanel = [NSOpenPanel openPanel];
	[openPanel setCanChooseFiles:YES];
	[openPanel setCanChooseDirectories:NO];
	[openPanel setAllowsMultipleSelection:YES];
	[openPanel setAllowsOtherFileTypes:NO];
	
	[openPanel beginSheetForDirectory:nil
								 file:nil
								types:[NSArray arrayWithObject:@"flv"]
					   modalForWindow:[self window]
						modalDelegate:self
					   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
						  contextInfo:NULL];
}

	 
- (void) openPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo
{
	if( returnCode == NSOKButton )
	{
		for( NSString* f in panel.filenames )
		{
			[flvPathsController addObject:f];
		}
	}
}


- (IBAction) inject:(id)sender
{
	NSError* error = nil;
	YamdiRunner* runner = [[YamdiRunner alloc] init];
	NSString* suffix = [[NSUserDefaults standardUserDefaults] stringForKey:@"outputFileSuffix"];
	
	for( NSString* f in flvPathsController.arrangedObjects )
	{
		NSString* outputPath = [[f stringByDeletingPathExtension] stringByAppendingString:
								[NSString stringWithFormat:@"-%@.flv", suffix]];
		NSLog( @"doing %@", f );
		
		NSString* xmlPath = nil;
		if( self.shouldOutputXML )
			xmlPath = [[f stringByDeletingPathExtension] stringByAppendingString:
					   [NSString stringWithFormat:@"-%@.xml", suffix]];
		
		runner.inputPath = f;
		runner.outputPath = outputPath;
		runner.addOnLastSecondEvent = self.shouldAddOnLastSecondEvent;
		if( self.shouldUseCreatorTag )
			runner.creatorTag = self.creatorTag;
		if( xmlPath )
			runner.xmlOutputPath = xmlPath;
		
		error = [runner run];
		if( error )
			NSLog( @"error: %@", error );
	}
}


- (IBAction) showPreferencesWindow:(id)sender
{
	[preferencesController showWindow:self];
}


#pragma mark Table View Delegate

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
    return NO;
}


- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op
{
	// make sure we're not dropping on ourself
	if( [info draggingSource] != tv )
	{
		[tv setDropRow:-1 dropOperation:NSTableViewDropOn];		
		return NSDragOperationEvery;
	}
	else
	{
		return NSDragOperationNone;
	}
}


- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)operation
{
	NSPasteboard* pboard = [info draggingPasteboard];
	if ( [[pboard types] containsObject:NSFilenamesPboardType] )
	{
		NSArray* filenames = [pboard propertyListForType:NSFilenamesPboardType];
		for( NSString* file in filenames )
		{
			if( [[[file pathExtension] lowercaseString] isEqualToString:@"flv"] )
			{
				[flvPathsController addObject:file];
			}
		}
		return YES;
	}
	
	return NO;
}


- (void)deleteSelectionFromTableView:(NSTableView *)tableView
{
	[flvPathsController removeObjectsAtArrangedObjectIndexes:[flvPathsController selectionIndexes]];
}

#pragma mark Accessors
// seems like there would be a better way to do this

- (BOOL) shouldAddOnLastSecondEvent
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldAddOnLastSecondEvent"];
}


- (void) setShouldAddOnLastSecondEvent:(BOOL)yn
{
	[[NSUserDefaults standardUserDefaults] setBool:yn forKey:@"shouldAddOnLastSecondEvent"];
}


- (NSString*) creatorTag
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"creatorTag"];
}


- (void) setCreatorTag:(NSString*)tag
{
	[[NSUserDefaults standardUserDefaults] setObject:tag forKey:@"creatorTag"];
}


- (BOOL) shouldUseCreatorTag
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldUseCreatorTag"];
}


- (void) setShouldUseCreatorTag:(BOOL)yn
{
	[[NSUserDefaults standardUserDefaults] setBool:yn forKey:@"shouldUseCreatorTag"];
}


- (BOOL) shouldOutputXML
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldOutputXML"];
}


- (void) setShouldOutputXML:(BOOL)yn
{
	[[NSUserDefaults standardUserDefaults] setBool:yn forKey:@"shouldOutputXML"];
}


@end
