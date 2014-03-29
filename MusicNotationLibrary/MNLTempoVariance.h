//
//  MNLTempoVariance.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-16.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLPlaceableStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLTempoVarianceType) {
	MNLTempoVarianceTypeBreathMark,
	MNLTempoVarianceTypeFermata,
	MNLTempoVarianceTypeAccelerando,
	MNLTempoVarianceTypeAllargando,
	MNLTempoVarianceTypeRallentando,
	MNLTempoVarianceTypeRitardando,
	MNLTempoVarianceTypeRitenuto,
	MNLTempoVarianceTypeRubato,
	MNLTempoVarianceTypeStringendo
};


@interface MNLTempoVariance : MNLPlaceableStaffItem

@property (nonatomic,assign) MNLTempoVarianceType type; // Default: MNLTempoVarianceTypeBreathMark;
@property (nonatomic,assign) int delay; // in 16th note units, only applies to Fermata and Breath Mark

@end
