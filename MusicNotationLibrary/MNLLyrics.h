//
//  MNLLyrics.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MNLSyllableAlignment) {
	MNLSyllableAlignmentNoteStart,
	MNLSyllableAlignmentStandard
};
typedef NS_ENUM(NSUInteger, MNLStaffAlignment) {
	MNLStaffAlignmentBottom,
	MNLStaffAlignmentTop
};


@interface MNLLyrics : NSObject

@property (nonatomic,assign) MNLSyllableAlignment alignSyllable;
@property (nonatomic,assign) MNLStaffAlignment alignStaff;
@property (nonatomic,assign) int verticalOffset;

@property (nonatomic,retain) NSArray *lines;

@end
