//
//  NWC.m
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2014-03-30.
//  Copyright (c) 2014 Cinus. All rights reserved.
//

#import "NWC.h"

NSString * const MNLParseException = @"MNLParseException";
NSString * const MNLErrorDomain = @"se.cinus.MusicNotationLibrary";

NSError *MNLMakeError(NSInteger code, NSString *localizedDescription, NSString *localizedReason)
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (localizedDescription)
        userInfo[NSLocalizedDescriptionKey] = localizedDescription;
    if (localizedReason)
        userInfo[NSLocalizedFailureReasonErrorKey] = localizedReason;
    
    return [NSError errorWithDomain:MNLErrorDomain
                               code:MNLErrorCode_UnrecognizedFileFormat
                           userInfo:userInfo];
}
int validate(int value, int from, int to, int def, NSString *name)
{
    if (value >= from && value <= to)
        return value;
    
    NSLog(@"WARN: Invalid %@: '%d' Defaulting to %d", name,value,def);
    return def;
}

@implementation NWC

@end
