//
//  YamdiOperation.m
//  FLVr Injector
//
//  Created by Andy Mroczkowski on 4/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "YamdiOperation.h"

#import "YamdiRunner.h"

@interface YamdiOperation ()
@property (nonatomic, retain) YamdiRunner* runner;
@end


@implementation YamdiOperation

@synthesize runner = _runner;

- (id) initWithYamdiRunner:(YamdiRunner *)runner
{
	self = [super init];
	if (self != nil)
	{
		self.runner = runner;
	}
	return self;
}


- (void) dealloc
{
	[_runner release];
	[super dealloc];
}


-(void) main
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	if( ![self isCancelled] )
	{
		NSError* error = [self.runner run];
	}
	[pool drain];
	[pool release];
}


@end
