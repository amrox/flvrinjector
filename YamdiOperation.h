//
//  YamdiOperation.h
//  FLVr Injector
//
//  Created by Andy Mroczkowski on 4/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class YamdiRunner;

@interface YamdiOperation : NSOperation
{
	YamdiRunner* _runner;
}

- (id)initWithYamdiRunner:(YamdiRunner *)runner;

@end
