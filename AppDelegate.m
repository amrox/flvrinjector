//
//  AppDelegate.m
//  FLVrInjectr
//
//  Created by Andy Mroczkowski on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "YamdiRunner.h"


const int kSaveDestinationSameAsOriginalTag = 100;
const int kSaveDestinationChooseTag         = 101;

@implementation AppDelegate


//@synthesize shouldUseCreatorTag = _shouldUseCreatorTag;
//@synthesize creatorTag = _creatorTag;
//@synthesize shouldAddOnLastSecondEvent = _shouldAddOnLastSecondEvent;
//@synthesize shouldOutputXML = _shouldOutputXML;
//@synthesize outputMode = _outputMode;

@synthesize recentSaveLocations = _recentSaveLocations;
@synthesize recentSaveLocationsMax = _recentSaveLocationsMax;

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
//	self.outputMode = kOutputModeInPlace;  // TODO: fix
	//[saveOptionMatrix setEnabled:NO];
	
}


- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[[NSUserDefaults standardUserDefaults] setObject:self.recentSaveLocations
											  forKey:@"recentSaveLocations"];
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
    [filesTableView registerForDraggedTypes:
	 [NSArray arrayWithObject:NSFilenamesPboardType]];	

	// -- save location stuff
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	self.recentSaveLocationsMax = [defaults integerForKey:@"recentSaveLocationsMax"];
	self.recentSaveLocations = [NSMutableArray arrayWithCapacity:self.recentSaveLocationsMax];
	[self.recentSaveLocations addObjectsFromArray:[defaults arrayForKey:@"recentSaveLocations"]];
	[self rebuildChooseSaveLocationMenu];
	
//	NSString* lastSavePath = [defaults stringForKey:<#(NSString *)defaultName#>
	
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
	
	for( NSString* f in flvPathsController.arrangedObjects )
	{
		NSLog( @"doing %@", f );

		if( self.outputMode == kOutputModeInPlace )
		{
			// move the source to a temporary folder
			NSString* newFileName = [f stringByAppendingStringToFilename:@"-original"];
			NSString* newPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[newFileName lastPathComponent]];
			[[NSFileManager defaultManager] removeFileAtPath:newPath handler:nil];
			if( [[NSFileManager defaultManager] movePath:f toPath:newPath handler:nil] )
			{
				error = [self injectForInputFile:newPath outputFile:f];
				if( !error )
				{
					// trash the originals
					FSRef ref;
					if( [newPath getFSRef:&ref] )
					{
						FSMoveObjectToTrashSync( &ref, NULL, 0 );
					}
					else
					{
						// TODO: error
					}
				}
			}
			else
			{
				// TODO: error
			}
		}
		
		else if( self.outputMode == kOutputModeNewFile )
		{
			NSString* outputFile = nil;
			NSString* outputDir = [[chooseSaveLocationPopupButton selectedItem] representedObject];
			if( outputDir )
			{
				outputFile = [outputDir stringByAppendingPathComponent:[f lastPathComponent]];
			}
			else  // "same location as original" mode
			{
				NSString* suffix = [[NSUserDefaults standardUserDefaults] stringForKey:@"outputFileSuffix"];
				outputFile = [f stringByAppendingStringToFilename:[NSString stringWithFormat:@"-%@", suffix]];
			}
			error = [self injectForInputFile:f outputFile:outputFile];
		}
	}
	
	if( !error )
	{
		[flvPathsController removeObjects:[flvPathsController arrangedObjects]];
	}
}


- (NSError *) injectForInputFile:(NSString *)inputPath outputFile:(NSString *)outputPath
{
	NSError *error = nil;
	NSString* xmlPath = nil;
	YamdiRunner* runner = [[YamdiRunner alloc] init];
	if( self.shouldOutputXML )
		xmlPath = [[outputPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"xml"];
	
	runner.inputPath = inputPath;
	runner.outputPath = outputPath;
	runner.addOnLastSecondEvent = self.shouldAddOnLastSecondEvent;
	if( self.shouldUseCreatorTag )
		runner.creatorTag = self.creatorTag;
	if( xmlPath )
		runner.xmlOutputPath = xmlPath;
	
	error = [runner run];
	if( error )
		NSLog( @"error: %@", error );
	return error;
}


- (IBAction) showPreferencesWindow:(id)sender
{
	[preferencesController showWindow:self];
}


- (IBAction) chooseSaveLocation:(id)sender
{
	NSOpenPanel* panel = [NSOpenPanel openPanel];
	[panel setCanChooseFiles:NO];
	[panel setCanChooseDirectories:YES];
	[panel setCanCreateDirectories:YES];
	[panel beginSheetForDirectory:nil
								 file:nil
					   modalForWindow:[self window]
						modalDelegate:self
					   didEndSelector:@selector(chooseSaveLocationPanelDidEnd:returnCode:contextInfo:)
						  contextInfo:NULL];
	
}


- (void) chooseSaveLocationPanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	if( returnCode == NSOKButton )
	{
		[self addNewRecentPath:[sheet filename]];
		[self rebuildChooseSaveLocationMenu];		
		self.outputLocationMenuItemIndex = [[chooseSaveLocationPopupButton menu] indexOfItemWithRepresentedObject:
											[[sheet filename] stringByAbbreviatingWithTildeInPath]];
	}
}


- (void) rebuildChooseSaveLocationMenu
{
	NSMenu* chooseSaveLocationMenu = [chooseSaveLocationPopupButton menu];
	NSMutableArray* itemsToRemove = [NSMutableArray arrayWithCapacity:self.recentSaveLocationsMax];
	for( NSMenuItem* item in [chooseSaveLocationMenu itemArray] )
	{
		if( ([item tag] != kSaveDestinationSameAsOriginalTag)
			&& ([item tag] != kSaveDestinationChooseTag)
			&& (![item isSeparatorItem]) )
		{
			[itemsToRemove addObject:item];
		}
	}
	
	for( NSMenuItem* item in itemsToRemove )
	{
		[chooseSaveLocationMenu removeItem:item];
	}

	NSUInteger insertIndex = 2;
	for( NSString* p in self.recentSaveLocations )
	{
		NSMenuItem* item = [[NSMenuItem alloc] initWithTitle:[[p stringByStandardizingPath] lastPathComponent]
										  action:NULL
								   keyEquivalent:@""];
		[item setRepresentedObject:p];
		[item setTag:insertIndex];
		[chooseSaveLocationMenu insertItem:item atIndex:insertIndex];
		[item release];
		insertIndex++;
	}
	
	// reset the selection
	[chooseSaveLocationPopupButton selectItemAtIndex:self.outputLocationMenuItemIndex];
}


- (void) addNewRecentPath:(NSString *)path
{
	NSString* abbrevPath = [path stringByAbbreviatingWithTildeInPath];
	
	// if the path is already in our list, remove it and add it again so its at the top
	if( [self.recentSaveLocations containsObject:abbrevPath] )
	{
		[self.recentSaveLocations removeObject:abbrevPath];
	}
	
	// add the path
	[self.recentSaveLocations insertObject:abbrevPath atIndex:0];
	
	// make sure we're not over the size limit
	while( [self.recentSaveLocations count] > self.recentSaveLocationsMax )
	{
		[self.recentSaveLocations removeLastObject];
	}
}


#pragma mark Table View Delegate

- (BOOL) tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
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


- (NSInteger) outputMode
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"outputMode"];
}


- (void)setOutputMode:(NSInteger)mode
{
	[[NSUserDefaults standardUserDefaults] setInteger:mode forKey:@"outputMode"];
}

- (NSInteger) outputLocationMenuItemIndex
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:@"outputLocationMenuItemIndex"];
}


- (void)setOutputLocationMenuItemIndex:(NSInteger)index
{
	[[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"outputLocationMenuItemIndex"];
}

@end
