//
//  MNLClef.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLClefType) {
	MNLClefTypeTreble,
	MNLClefTypeBass,
	MNLClefTypeAlto,
	MNLClefTypeTenor
};
typedef NS_ENUM(NSUInteger, MNLClefOctaveShift) {
	MNLClefOctaveShiftNone,
	MNLClefOctaveShiftUp,
	MNLClefOctaveShiftDown
};


@interface MNLClef : MNLStaffItem

@property (nonatomic,assign) MNLClefType type;
@property (nonatomic,assign) MNLClefOctaveShift octaveShift;

@end
