//
//  YamdiRunner_Test.m
//  FLVrInjectr
//
//  Created by Andy Mroczkowski on 3/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "YamdiRunner_Test.h"

#import "YamdiRunner.h"

@implementation YamdiRunner_Test

- (void)testRun
{
	NSString* testFilePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"taste_the_fame"
																			  ofType:@"flv"];
	STAssertNotNil( testFilePath, @"could not find file %@", testFilePath );
	
	NSString* outputPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[testFilePath lastPathComponent]];
	
	YamdiRunner* yamdiRunner = [[YamdiRunner alloc] init];
	yamdiRunner.inputPath = testFilePath;
	yamdiRunner.outputPath = outputPath;
	
	NSError* error = [yamdiRunner run];
	STAssertNil( error, @"error: %@", error );
	
	NSFileManager* fm = [NSFileManager defaultManager];
	BOOL exists = [fm fileExistsAtPath:outputPath];
	STAssertTrue( exists, @"output file not found: %@", outputPath );
	
	if( exists )
		[fm removeFileAtPath:outputPath handler:NULL];
}

@end
