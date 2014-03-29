//
//  MNLPlaceableStaffItem.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-16.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLPlaceableStaffItemJustify) {
	MNLPlaceableStaffItemJustifyLeft,
	MNLPlaceableStaffItemJustifyCenter,
	MNLPlaceableStaffItemJustifyRight
};
typedef NS_ENUM(NSUInteger, MNLPlaceableStaffItemAlign) {
	MNLPlaceableStaffItemAlignBestFit,
	MNLPlaceableStaffItemAlignBeforeOtherStaffSignatures,
	MNLPlaceableStaffItemAlignAfterOtherStaffSignatures,
	MNLPlaceableStaffItemAlignAtNextNote
};

@interface MNLPlaceableStaffItem : MNLStaffItem
@property (nonatomic,assign) int staffPosition;
@property (nonatomic,assign) bool preserveWidth;
@property (nonatomic,assign) MNLPlaceableStaffItemJustify justification;
@property (nonatomic,assign) MNLPlaceableStaffItemAlign alignment;

@end
