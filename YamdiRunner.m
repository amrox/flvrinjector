//
//  YamdiRunner.m
//  FLVrInjectr
//
//  Created by Andy Mroczkowski on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "YamdiRunner.h"

const int kYamdiMaxArgCount = 9;

@implementation YamdiRunner

NSString *yamdiPath = nil;

+ (void) initialize
{
	yamdiPath = [[[[[NSBundle mainBundle] executablePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"yamdi"] retain];
}

@synthesize inputPath = _inputPath;
@synthesize outputPath = _outputPath;
@synthesize creatorTag = _creatorTag;
@synthesize xmlOutputPath = _xmlOutputPath;
@synthesize addOnLastSecondEvent = _addOnLastSecondEvent;

- (NSError *)run
{
	NSError* error = nil;
	NSMutableArray* args = [NSMutableArray arrayWithCapacity:kYamdiMaxArgCount];
	
	// -- inputPath
	if( self.inputPath )
	{
		[args addObject:@"-i"];
		[args addObject:[self.inputPath stringByStandardizingPath]]; 
	}
	else
	{
		goto bail;
	}
	
	// -- outputPath
	if( self.outputPath )
	{
		[args addObject:@"-o"];
		[args addObject:[self.outputPath stringByStandardizingPath]];
	}
	else
	{
		goto bail;
	}
	
	// -- creatorTag
	if( self.creatorTag)
	{
		[args addObject:@"-c"];
		[args addObject:self.creatorTag];
	}
	
	// -- xmlOutputPath
	if( self.xmlOutputPath )
	{
		[args addObject:@"-x"];
		[args addObject:[self.xmlOutputPath stringByStandardizingPath]];
	}
	
	if( self.addOnLastSecondEvent )
	{
		[args addObject:@"-l"];
	}
	
	NSLog( @"yamdiPath: %@", yamdiPath );
	NSTask* task = [NSTask launchedTaskWithLaunchPath:yamdiPath
											arguments:args];
	
	[task waitUntilExit];
	
bail:
	return error;
}

@end
