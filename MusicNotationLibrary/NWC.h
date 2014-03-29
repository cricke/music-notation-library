//
//  NWC.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2014-03-30.
//  Copyright (c) 2014 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>


// 0x17 = 23 => "1.90"
// 0x11 = 17 => "1.90"
// 0x10 = 16 => "1.75b"
#define NW_VERSION_COMMON 16
#define NW_VERSION_LEGACY 15
#define NW_VERSION_LEGACY_2 9


#define OUTPUT_PARSER_DEBUG_STAFF 0
#define OUTPUT_PARSER_DEBUG_LYRICS 0
#define OUTPUT_PARSER_DEBUG_STAFFITEM 0
#define OUTPUT_PARSER_DEBUG_STAFFITEM_NOTE 0
#define OUTPUT_PARSER_DEBUG_FONT 0


//TODO: Move to category? +Error
extern NSString * const MNLParseException;
extern NSString * const MNLErrorDomain;

typedef NS_ENUM(NSInteger, MNLErrorCode) {
    //    MNLErrorCode_FileIsEmpty             = -1,
    MNLErrorCode_UnrecognizedFileFormat  = -2,
    MNLErrorCode_ParseError              = -3
};

NSError *MNLMakeError(NSInteger code, NSString *localizedDescription, NSString *localizedReason);

int validate(int value, int from, int to, int def, NSString *name);


@interface NWC : NSObject

@end
