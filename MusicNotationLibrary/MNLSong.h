//
//  MNLSong.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-11.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MNLMeasureNumberingStyle) {
	MNLMeasureNumberingStyleNone,
	MNLMeasureNumberingStylePlain,
	MNLMeasureNumberingStyleCircled,
	MNLMeasureNumberingStyleBoxed
};
typedef NS_ENUM(NSUInteger, MNLStaffLabelPrintStyle) {
	MNLStaffLabelPrintStyleNone,
	MNLStaffLabelPrintStyleFirstSystem,
	MNLStaffLabelPrintStyleTopSystem,
	MNLStaffLabelPrintStyleAllSystems
};


@interface MNLSong : NSObject

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *author;
@property (nonatomic,retain) NSArray *copyrightNotices;
@property (nonatomic,retain) NSString *comments;

@property (nonatomic,assign) bool lastSystemExtended;
@property (nonatomic,assign) bool spacingIncreasedWithLongerNotes;
@property (nonatomic,assign) MNLMeasureNumberingStyle measureNumberingStyle;
@property (nonatomic,assign) int measureNumberingStart;
@property (nonatomic,assign) bool titlePageInfo;
@property (nonatomic,assign) MNLStaffLabelPrintStyle staffLabelsPrintStyle;
@property (nonatomic,assign) bool pageNumberingEnabled;
@property (nonatomic,assign) int pageNumberingFrom;

// Unit: inches
@property (nonatomic,assign) double_t pageMarginTop;
@property (nonatomic,assign) double_t pageMarginInside;
@property (nonatomic,assign) double_t pageMarginOutside;
@property (nonatomic,assign) double_t pageMarginBottom;

@property (nonatomic,assign) bool mirrorMargins; //double-sided print
@property (nonatomic,retain) NSArray *visibleStavesByIndex; // 255 is max num staves in NW

@property (nonatomic,assign) bool layeringAllowed;
@property (nonatomic,assign) int staffSize; // in points

@property (nonatomic,retain) NSArray *fonts;

@property (nonatomic,retain) NSArray *staves;

@end
