//
//  MNLTempoMarking.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLPlaceableStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLTempoMarkingBase) {
	MNLTempoMarkingBaseEighth,
	MNLTempoMarkingBaseDottedEighth,
	MNLTempoMarkingBaseQuarter,
	MNLTempoMarkingBaseDottedQuarter,
	MNLTempoMarkingBaseHalf,
	MNLTempoMarkingBaseDottedHalf
};

@interface MNLTempoMarking : MNLPlaceableStaffItem

@property (nonatomic,assign) int bpm;
@property (nonatomic,assign) MNLTempoMarkingBase base;
@property (nonatomic,retain) NSString *text;


@end
