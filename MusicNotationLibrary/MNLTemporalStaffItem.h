//
//  MNLTemporalStaffItem.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-17.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLStaffItem.h"


typedef NS_ENUM(NSUInteger, MNLTemporalDuration) {
	MNLTemporalDurationWhole,
	MNLTemporalDurationHalf,
	MNLTemporalDurationQuarter,
	MNLTemporalDurationEighth,
	MNLTemporalDurationSixteenth,
	MNLTemporalDurationThirtySecondth,
	MNLTemporalDurationSixtyFourth
};
typedef NS_ENUM(NSUInteger, MNLTemporalDurationModifier) {
	MNLTemporalDurationModifierNormal,
	MNLTemporalDurationModifierDotted,
	MNLTemporalDurationModifierDoubleDotted
};
typedef NS_ENUM(NSUInteger, MNLTupletInfo) {
	MNLTupletInfoNone,
	MNLTupletInfoTriplet
};
typedef NS_ENUM(NSUInteger, MNLStemDirection) {
	MNLStemDirectionAuto,
	MNLStemDirectionUp,
	MNLStemDirectionDown
};
typedef NS_ENUM(NSUInteger, MNLBeamInfo) {
	MNLBeamInfoNone,
	MNLBeamInfoBeamedWithNext,
	MNLBeamInfoBeamedWithBoth,
	MNLBeamInfoBeamedWithPrevious
};
typedef NS_ENUM(NSUInteger, MNLSlurInfo) {
	MNLSlurInfoNone,
	MNLSlurInfoBeamedWithNext,
	MNLSlurInfoBeamedWithBoth,
	MNLSlurInfoBeamedWithPrevious
};
typedef NS_ENUM(UInt8, MNLSlurDirection) {
	MNLSlurDirectionDefault,
	MNLSlurDirectionUpward,
	MNLSlurDirectionDownward
};
typedef NS_ENUM(NSUInteger, MNLLyricsSyllable) {
	MNLLyricsSyllableDefault,
	MNLLyricsSyllableAlways,
	MNLLyricsSyllableNever
};
typedef NS_ENUM(NSUInteger, MNLTieDirection) {
	MNLTieDirectionDefault,
	MNLTieDirectionUpward,
	MNLTieDirectionDownward
};

/*
typedef NS_ENUM(NSUInteger, MNLTieInfo) {
	MNLTieInfoNone                  = 0,
	MNLTieInfoBeamedWithNext		= 1,
	MNLTieInfoBeamedWithBoth		= 2,
	MNLTieInfoBeamedWithPrevious	= 3
};
*/


@interface MNLTemporalStaffItem : MNLStaffItem

@property (nonatomic,assign) MNLTemporalDuration duration; // = QUARTER;
@property (nonatomic,assign) MNLTemporalDurationModifier durationModifier; // = NORMAL;
@property (nonatomic,assign) MNLTupletInfo tupletGrouping; // = NO_TUPLET;
@property (nonatomic,assign) MNLStemDirection stemDirection; // = STEM_AUTO;
@property (nonatomic,assign) int extraAccidentalSpacing; // = 0;	// 0-7
@property (nonatomic,assign) int extraNoteSpacing; // = 0; 		// 0-3

@property (nonatomic,assign) MNLBeamInfo beamInfo; // = BEAMED_NONE;
@property (nonatomic,assign) MNLSlurInfo slurInfo; // = SLUR_NONE;
@property (nonatomic,assign) MNLSlurDirection slurDirection; // = SLUR_DIRECTION_DEFAULT;
@property (nonatomic,assign) bool slurDirectionEnabled; // = false;
@property (nonatomic,assign) bool tieDirectionEnabled; // = false;
@property (nonatomic,assign) bool staccato; // = false;
@property (nonatomic,assign) bool accent; // = false;
@property (nonatomic,assign) bool tenuto; // = false;
@property (nonatomic,assign) bool graceNote; // = false;

@property (nonatomic,assign) MNLLyricsSyllable lyricsSyllable; // = LyricsSyllableDefault
//@property (nonatomic,assign) bool lyricsSyllableAlways; // = false;
//@property (nonatomic,assign) bool lyricsSyllableNever; // = false;

@end
