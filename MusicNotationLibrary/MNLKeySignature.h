//
//  MNLKeySignature.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MNLStaffItem.h"


@interface MNLKeySignature : MNLStaffItem
{
	MNLAccidentals __keymodifier[7];
}

@property (nonatomic,assign) MNLAccidentals *keymodifier;

- (void)resetAllModifiers;

@end
