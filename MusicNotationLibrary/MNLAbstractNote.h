//
//  MNLAbstractNote.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-17.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLTemporalStaffItem.h"

@interface MNLAbstractNote : MNLTemporalStaffItem

@property (nonatomic,assign) int noteValue;
@property (nonatomic,assign) MNLAccidentals toneModifier; // = MNLAccidentalsNormal;
@property (nonatomic,assign) bool muted;
@property (nonatomic,assign) bool withoutLegerLines;

//@property (nonatomic,assign) MNLTieInfo tieInfo; // = TIE_NONE;
@property (nonatomic,assign) MNLTieDirection tieDirection; // = MNLTieDirectionDefault;
@property (nonatomic,assign) bool tieDirectionEnabled; // = false;

@end
