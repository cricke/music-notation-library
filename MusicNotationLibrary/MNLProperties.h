//
//  MNLProperties.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2014-03-29.
//  Copyright (c) 2014 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MNLColor) {
	MNLColorDefault,
	MNLColorHighlight1,
	MNLColorHighlight2,
	MNLColorHighlight3
};
typedef NS_ENUM(NSUInteger, MNLAccidentals) {
	MNLAccidentalsSharp,
	MNLAccidentalsFlat,
	MNLAccidentalsNatural,
	MNLAccidentalsDoubleSharp,
	MNLAccidentalsDoubleFlat,
	MNLAccidentalsNormal
};
