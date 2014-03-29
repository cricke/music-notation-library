//
//  MNLCompositeNote.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-16.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLCompositeStaffItem.h"

@interface MNLCompositeNote : MNLCompositeStaffItem

@property (nonatomic,retain) NSArray *components;

@end
