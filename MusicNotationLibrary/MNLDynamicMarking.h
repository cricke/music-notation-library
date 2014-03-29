//
//  MNLDynamicMarking.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLPlaceableStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLDynamicMarkingType) {
	MNLDynamicMarkingTypePPP,
	MNLDynamicMarkingTypePP,
	MNLDynamicMarkingTypeP,
	MNLDynamicMarkingTypeMP,
	MNLDynamicMarkingTypeMF,
	MNLDynamicMarkingTypeF,
	MNLDynamicMarkingTypeFF,
	MNLDynamicMarkingTypeFFF
};


@interface MNLDynamicMarking : MNLPlaceableStaffItem

@property (nonatomic,assign) MNLDynamicMarkingType dynamic;
@property (nonatomic,assign) bool overrideNoteVelocity;
@property (nonatomic,assign) bool overrideMidiVolume;
@property (nonatomic,assign) int defaultNoteVelocity;
@property (nonatomic,assign) int defaultMidiVolume;

@end
