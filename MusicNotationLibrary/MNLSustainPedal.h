//
//  MNLSustainPedal.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-16.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLPlaceableStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLSustainPedalStyle) {
	MNLSustainPedalStyleDown,
	MNLSustainPedalStyleRelease
};


@interface MNLSustainPedal : MNLPlaceableStaffItem

@property (nonatomic,assign) MNLSustainPedalStyle style;

@end
