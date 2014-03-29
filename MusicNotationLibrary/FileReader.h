//
//  FileReader.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileReader : NSObject

+ (FileReader *)fileReaderWithPath:(NSString *)path error:(NSError **)err;

- (BOOL)inflateWithError:(NSError **)err;


- (int)nextUnsignedByte;
- (int)nextSignedByte;

- (int)nextUnsignedShort;
- (int)nextSignedShort;
- (int)nextSignedShortFunky;

- (BOOL)nextYNBoolean;
- (BOOL)nextBoolean;
- (NSArray *)nextBooleanArray:(NSUInteger)numBytes;

- (NSString *)nextNullTerminatedString;
- (NSArray *)nextNullTerminatedStrings:(NSUInteger)numBytes;

- (BOOL)isEof;
- (void)skipBytes:(NSUInteger)numBytes;
- (const void *)peek:(NSUInteger)numBytes;
- (const void *)peek:(NSUInteger)numBytes offset:(NSUInteger)offset;

@end
