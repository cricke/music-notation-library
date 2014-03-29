//
//  NWCParser.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-11.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNLSong.h"






@interface NWCParser : NSObject <NSStreamDelegate>



+ (MNLSong *)parseNwcFile:(NSString *)path error:(NSError **)err;

@end
