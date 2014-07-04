//
//  MNLCompositeStaffItem.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2014-01-22.
//  Copyright (c) 2014 Cinus. All rights reserved.
//

#import "MNLTemporalStaffItem.h"

@interface MNLCompositeStaffItem : MNLTemporalStaffItem

@property (nonatomic,retain) NSArray *components;

@end
