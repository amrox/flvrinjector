//
//  NSString+AMXExtensions_Test.m
//  FLVr Injector
//
//  Created by Andy Mroczkowski on 4/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSString+AMXExtensions_Test.h"

#import "NSString+AMXExtensions.h"

@implementation NSString_AMXExtensions_Test

- (void)testBasic
{
	NSString* path = @"/the/path/to/a/file.txt";
	NSString* appendedPath = [path stringByAppendingStringToFilename:@"-new"];
	NSString* correctPath = @"/the/path/to/a/file-new.txt";
	
	STAssertTrue( [appendedPath isEqualToString:correctPath], @"'%@' not equal to '%@'", appendedPath, correctPath );	
}


- (void)testNilAppend
{
	NSString* path = @"/the/path/to/a/file.txt";
	NSString* appendedPath = [path stringByAppendingStringToFilename:nil];
	STAssertTrue( [appendedPath isEqualToString:path], @"'%@' not equal to '%@'", appendedPath, path );	
	
}

@end
