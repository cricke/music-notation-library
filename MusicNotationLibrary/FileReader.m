//
//  FileReader.m
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "FileReader.h"
#import "NSData+zlib.h"

@interface FileReader ()
{
	int _curPos;
	const char *_bytes;
}
@property (nonatomic) NSData *data;
@end

@implementation FileReader

+ (FileReader *)fileReaderWithPath:(NSString *)path error:(NSError **)err
{
    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:err];
    if (data == nil)
        return nil;
	
	FileReader *reader = [[FileReader alloc] initWithData:data];
    if (reader == nil)
    {
        //TODO: Set err
    }
	return reader;
}

- (id)initWithData:(NSData *)data
{
	self = [super init];
	if (self)
	{
        _data = data;
		_bytes = (const void *)[_data bytes];
		_curPos = 0;
	}
	return self;
}


- (BOOL)inflateWithError:(NSError **)err
{
	NSData *subdata = [_data subdataWithRange:NSMakeRange(_curPos, _data.length - _curPos)];
	subdata = [subdata dataByInflatingWithError:err];
	if (subdata == nil)
		return NO;
	
	self.data = subdata;
	_bytes = [_data bytes];
	_curPos = 0;
	return YES;
}

- (int)nextUnsignedByte
{
	unsigned char unsignedByte = _bytes[_curPos++];
	return (unsignedByte & 0xFF);
}
- (int)nextSignedByte
{
	signed char signedByte = _bytes[_curPos++];
	return (int) signedByte;
}
- (int)nextUnsignedShort
{
	uint16_t unsignedShort = OSReadLittleInt16(_bytes, _curPos);
	_curPos += 2;
	return (unsignedShort & 0xFFFF);
}
- (int)nextSignedShort
{
    int16_t signedShort = OSReadLittleInt16(_bytes, _curPos);
	_curPos += 2;
	return (int) signedShort;
}
- (int)nextSignedShortFunky
{
    // Examples: 08 7d => 2
    // 0000 1000 0111 1101
    
    //TODO: WTF?!?
	signed char byte = _bytes[_curPos++];
    byte = (byte & 253) >> 2;
    _curPos++;
    
	return (int) byte;
/*
	uint16_t unsignedShort = OSReadLittleInt16(_bytes, _curPos);
	unsignedShort = unsignedShort >> 2;
	_curPos += 2;
	return unsignedShort;
*/
}
- (BOOL)nextYNBoolean
{
	char ynboolean = _bytes[_curPos++];
	return ((ynboolean & 0xFF) == 89); // ON=89='Y', OFF=78='N'
}
- (BOOL)nextBoolean
{
	char boolean = _bytes[_curPos++];
	return ((boolean & 1) == 1);
}
- (NSArray *)nextBooleanArray:(NSUInteger)numBytes
{
    // buf holds a sequence of bits, one for every potential staff in the song,
    // i.e. max 256 staves (in reality it's 255)
    // 1 means the staff is visible, 0 means it's NOT visible

    NSMutableArray *ba = [[NSMutableArray alloc] initWithCapacity:(numBytes*8)];
    const char *buf = _bytes + _curPos;

    //NSLog(@"Raw: %@", [self peek:numBytes]);

    for (int i=0; i<numBytes; i++)
    {
        for (int j=0; j<8; j++)
        {
            //NSLog(@"Checking %d: %X & %d = %X", i*8 + j, (buf[i]&0xFF), (1 << j), (buf[i] & (1 << j)));
            if ((buf[i] & (1 << j)) == 0)
                ba[i*8 + j] = @(NO);
            else {
                ba[i*8 + j] = @(YES);
                //NSLog(@"Staff %d is visible", (i*8 + j));
            }
        }
    }

    [self skipBytes:numBytes];
    return ba;
}
- (NSString *)nextNullTerminatedString
{
	NSUInteger i = _curPos;
	for (; i < _data.length; i++)
	{
		if (_bytes[i] == 0x00)
			break;
	}
	NSInteger len = i - _curPos;
	
	// ISO-8859-1 encoded
	//NSString *string = [[NSString alloc] initWithBytes:(_bytes+_curPos) length:len encoding:NSISOLatin1StringEncoding];
	NSString *string = [[NSString alloc] initWithBytes:(_bytes+_curPos) length:len encoding:NSASCIIStringEncoding];
	_curPos += (len+1);
	return string;
}
- (NSArray *)nextNullTerminatedStrings:(NSUInteger)numBytes
{
	int index = 0;
    int last_sep_index = 0;
	NSMutableArray * lines = [[NSMutableArray alloc] init];
	Byte sep = 0x00;
	do {
		if (sep == _bytes[_curPos + index])
		{
            int chunk_len = index - last_sep_index;
            if (chunk_len != 0)
            {
                NSString *string = [[NSString alloc] initWithBytes:(_bytes+_curPos+last_sep_index) length:chunk_len encoding:NSASCIIStringEncoding];
                [lines addObject:string];
            }

			last_sep_index = index + 1;

			continue;
		}
	} while (index++ < numBytes);
	
	//NSLog(@"nextNullTerminatedStrings:%@:",lines);
	_curPos += numBytes;
	return lines;
}

- (BOOL)isEof
{
    return (_curPos == _data.length);
}
- (void)skipBytes:(NSUInteger)numBytes
{
	//NSData *subdata = [_data subdataWithRange:NSMakeRange(_curPos, numBytes)];
	//NSLog(@"Skipping: %@",subdata);
	
	_curPos += numBytes;
}
- (const void *)peek:(NSUInteger)numBytes
{
	NSData *subdata = [_data subdataWithRange:NSMakeRange(_curPos, numBytes)];
	return (__bridge const void *)(subdata);
	//return (_bytes + _curPos);
}
- (const void *)peek:(NSUInteger)numBytes offset:(NSUInteger)offset
{
	NSData *subdata = [_data subdataWithRange:NSMakeRange(_curPos+offset, numBytes)];
	return (__bridge const void *)(subdata);
	//return (_bytes + _curPos);
}


@end
