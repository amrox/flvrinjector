//
//  NSString+AMXExtensions.m
//  FLVr Injector
//
//  Created by Andy Mroczkowski on 4/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+AMXExtensions.h"


@implementation NSString (AMXExtensions)

- (NSString *)stringByAppendingStringToFilename:(NSString *)append
{
	if( !append )
		return self;
	
	NSString* extension = [self pathExtension];
	NSString* newFileName = [[[[self lastPathComponent] stringByDeletingPathExtension] stringByAppendingString:append] stringByAppendingPathExtension:extension];
	return [[self stringByDeletingLastPathComponent] stringByAppendingPathComponent:newFileName];	
}

- (BOOL)getFSRef:(FSRef *)aFSRef
{
	return FSPathMakeRef( (const UInt8 *)[self fileSystemRepresentation], aFSRef, NULL ) == noErr;
}

@end
