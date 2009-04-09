//
//  NSString+AMXExtensions.h
//  FLVr Injector
//
//  Created by Andy Mroczkowski on 4/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (AMXExtensions)

- (NSString *)stringByAppendingStringToFilename:(NSString *)append;

// from cocoadev
- (BOOL)getFSRef:(FSRef *)aFSRef;

@end
