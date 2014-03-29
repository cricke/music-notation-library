//
//  MNLTimeSignature.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLTimeSignatureStyle) {
	MNLTimeSignatureStyleStandard,
	MNLTimeSignatureStyleCommonTime,
	MNLTimeSignatureStyleAllaBreve
};


@interface MNLTimeSignature : MNLStaffItem

@property (nonatomic,assign) MNLTimeSignatureStyle style;
@property (nonatomic,assign) int beatsPerMinute;
@property (nonatomic,assign) int beatValue;

@end
