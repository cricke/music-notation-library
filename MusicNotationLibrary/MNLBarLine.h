//
//  MNLBarLine.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLBarLineStyle) {
	MNLBarLineStyleSingle,
	MNLBarLineStyleDouble,
	MNLBarLineStyleSectionOpen,
	MNLBarLineStyleSectionClose,
	MNLBarLineStyleLocalRepeatOpen,
	MNLBarLineStyleLocalRepeatClose,
	MNLBarLineStyleMasterRepeatOpen,
	MNLBarLineStyleMasterRepeatClose
};


@interface MNLBarLine : MNLStaffItem

@property (nonatomic,assign) MNLBarLineStyle barStyle;
@property (nonatomic,assign) bool forceSystemBreak; // top staff only
@property (nonatomic,assign) int repeatCount;

@end
