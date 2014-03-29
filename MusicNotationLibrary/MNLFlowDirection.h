//
//  MNLFlowDirection.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-16.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLPlaceableStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLFlowDirectionStyle) {
	MNLFlowDirectionStyleCoda,
	MNLFlowDirectionStyleSegno,
	MNLFlowDirectionStyleFine,
	MNLFlowDirectionStyleToCoda,
	MNLFlowDirectionStyleDaCapo,
	MNLFlowDirectionStyleDCAlCoda,
	MNLFlowDirectionStyleDCAlFine,
	MNLFlowDirectionStyleDalSegno,
	MNLFlowDirectionStyleDSAlCoda,
	MNLFlowDirectionStyleDSAlFine
};


@interface MNLFlowDirection : MNLPlaceableStaffItem

@property (nonatomic,assign) MNLFlowDirectionStyle style;

@end
