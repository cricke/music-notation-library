//
//  MNLStaffItem.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-11.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNLProperties.h"

typedef NS_ENUM(NSUInteger, MNLStaffItemVisibility) {
	MNLStaffItemVisibilityDefault,
	MNLStaffItemVisibilityAlwaysShow,
	MNLStaffItemVisibilityOnTopStaff,
	MNLStaffItemVisibilityNeverShow
};


@interface MNLStaffItem : NSObject

@property (nonatomic,assign) MNLStaffItemVisibility visibility;
@property (nonatomic,assign) MNLColor color;

@end
