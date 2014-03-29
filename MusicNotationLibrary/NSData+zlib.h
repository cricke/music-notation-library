//
//  NSData+zlib.h
//  MusicNotationLibrary
//
//	Taken from: https://github.com/bitbasenyc/nsdata-zlib
//
//  Created by Christian O. Andersson on 2013-07-11.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

// Requires adding libz.dylib

#import <Foundation/Foundation.h>

@interface NSData (zlib)

- (NSData *)dataByDeflating;
- (NSData *)dataByInflatingWithError:(NSError * __autoreleasing *)error;
- (BOOL)writeDeflatedToFile:(NSString *)path error:(NSError * __autoreleasing *)error;
- (BOOL)writeInflatedToFile:(NSString *)path error:(NSError * __autoreleasing *)error;

@end
