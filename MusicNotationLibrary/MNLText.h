//
//  MNLText.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-16.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLPlaceableStaffItem.h"

@interface MNLText : MNLPlaceableStaffItem

@property (nonatomic,assign) int fontId;
@property (nonatomic,retain) NSString *text;

@end
