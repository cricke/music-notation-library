//
//  MNLDynamicVariance.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-16.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLPlaceableStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLDynamicVarianceStyle) {
	MNLDynamicVarianceStyleCrescendo,
	MNLDynamicVarianceStyleDecrescendo,
	MNLDynamicVarianceStyleDiminuendo,
	MNLDynamicVarianceStyleRinforzando,
	MNLDynamicVarianceStyleSforzando
};

@interface MNLDynamicVariance : MNLPlaceableStaffItem

@property (nonatomic,assign) MNLDynamicVarianceStyle style;

@end
