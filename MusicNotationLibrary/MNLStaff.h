//
//  MNLStaff.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-11.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNLLyrics.h"
#import "MNLProperties.h"

typedef NS_ENUM(NSUInteger, MNLStaffStyle) {
	MNLStaffStyleStandard,
	MNLStaffStyleUpperGrandStaff,
	MNLStaffStyleLowerGrandStaff,
	MNLStaffStyleOrchestral
};
typedef NS_ENUM(NSUInteger, MNLEndingBarStyle) {
	MNLEndingBarStyleSectionClose,
	MNLEndingBarStyleMasterRepeatOpen,
	MNLEndingBarStyleSingle,
	MNLEndingBarStyleDouble,
	MNLEndingBarStyleOpen
};


@interface MNLStaff : NSObject

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *groupName;
@property (nonatomic,assign) MNLEndingBarStyle endingBarStyle;
@property (nonatomic,assign) bool muted;
@property (nonatomic,assign) int channelNumber;
@property (nonatomic,assign) int playbackDeviceIndex;
@property (nonatomic,assign) bool patchBankSelected;
@property (nonatomic,assign) int soundBank;
@property (nonatomic,assign) int instrumentPatchIndex;
@property (nonatomic,assign) MNLStaffStyle style;
@property (nonatomic,assign) int upperHeight;
@property (nonatomic,assign) int lowerHeight;
@property (nonatomic,assign) int numStaffLines;
@property (nonatomic,assign) bool layeredWithNextStaff;
@property (nonatomic,assign) int partVolume;
@property (nonatomic,assign) int stereoPan;
@property (nonatomic,assign) int transposition;
@property (nonatomic,assign) MNLColor color;

@property (nonatomic,assign) bool visible;
@property (nonatomic,retain) NSArray *items;
@property (nonatomic,retain) MNLLyrics *lyrics;

@end
