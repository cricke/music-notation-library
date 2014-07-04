//
//  MNLKeySignature.m
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLKeySignature.h"

@implementation MNLKeySignature

- (id)init
{
	self = [super init];
	if (self)
	{
        [self resetAllModifiers];
	}
	return self;
}

- (void)setKeymodifier:(MNLAccidentals *)keymodifier
{
	memcpy(__keymodifier, keymodifier, sizeof(__keymodifier));
}
- (MNLAccidentals *)keymodifier
{
	return __keymodifier;
}


- (void)resetAllModifiers
{
    // clear potential modifiers in current measure
    MNLAccidentals originalModifiers[] = {MNLAccidentalsNormal,MNLAccidentalsNormal,MNLAccidentalsNormal,MNLAccidentalsNormal,MNLAccidentalsNormal,MNLAccidentalsNormal,MNLAccidentalsNormal};
    [self setKeymodifier:originalModifiers];
}

@end
