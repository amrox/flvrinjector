//
//  YamdiRunner.h
//  FLVrInjectr
//
//  Created by Andy Mroczkowski on 3/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface YamdiRunner : NSObject
{
	NSString* _inputPath;
	NSString* _outputPath;
	NSString* _creatorTag;
	NSString* _xmlOutputPath;
	BOOL _addOnLastSecondEvent;
}

@property (nonatomic, retain) NSString *inputPath;
@property (nonatomic, retain) NSString *outputPath;
@property (nonatomic, retain) NSString *creatorTag;
@property (nonatomic, retain) NSString *xmlOutputPath;
@property (nonatomic, assign) BOOL addOnLastSecondEvent;

- (NSError *)run;

@end
