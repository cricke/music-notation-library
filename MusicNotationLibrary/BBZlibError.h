//
//  BBZlibError.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-11.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBZlibError : NSError

extern NSString *const BBZlibErrorDomain;

typedef NS_ENUM(NSUInteger, BBZlibErrorCode) {
    BBZlibErrorCodeFileTooLarge = 0,
    BBZlibErrorCodeDeflationError = 1,
    BBZlibErrorCodeInflationError = 2,
    BBZlibErrorCodeCouldNotCreateFileError = 3,
};

@end