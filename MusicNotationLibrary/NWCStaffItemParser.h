//
//  NWCStaffItemParser.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2014-03-30.
//  Copyright (c) 2014 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MNLStaffItem.h"
#import "FileReader.h"

@interface NWCStaffItemParser : NSObject

+ (MNLStaffItem *)staffItemFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;

+ (MNLStaffItem *)clefFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)keySignatureFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)barLineFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)specialEndingFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)instrumentPatchFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)timeSignatureFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)tempoMarkingFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)dynamicMarkingFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)noteFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)restFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)compositeNoteFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)sustainPedalFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)flowDirectionFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)multipointControllerFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)tempoVarianceFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)dynamicVarianceFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)performanceIndicatorFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)textFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;
+ (MNLStaffItem *)compositeRestFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion;

@end
