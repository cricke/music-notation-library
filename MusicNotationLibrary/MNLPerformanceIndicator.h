//
//  MNLPerformanceIndicator.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-16.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "MNLPlaceableStaffItem.h"

typedef NS_ENUM(NSUInteger, MNLPerformanceIndicatorStyle) {
	MNLPerformanceIndicatorStyleAdLibitum,
	MNLPerformanceIndicatorStyleAnimato,
	MNLPerformanceIndicatorStyleCantabile,
	MNLPerformanceIndicatorStyleConBrio,
	MNLPerformanceIndicatorStyleDolce,
	MNLPerformanceIndicatorStyleEspressivo,
	MNLPerformanceIndicatorStyleGrazioso,
	MNLPerformanceIndicatorStyleLegato,
	MNLPerformanceIndicatorStyleMaestoso,
	MNLPerformanceIndicatorStyleMarcato,
	MNLPerformanceIndicatorStyleMenoMosso,
	MNLPerformanceIndicatorStylePocoAPoco,
	MNLPerformanceIndicatorStylePiuMosso,
	MNLPerformanceIndicatorStyleSemplice,
	MNLPerformanceIndicatorStyleSimile,
	MNLPerformanceIndicatorStyleSolo,
	MNLPerformanceIndicatorStyleSostenuto,
	MNLPerformanceIndicatorStyleSottoVoce,
	MNLPerformanceIndicatorStyleStaccato,
	MNLPerformanceIndicatorStyleSubito,
	MNLPerformanceIndicatorStyleTenuto,
	MNLPerformanceIndicatorStyleTutti,
	MNLPerformanceIndicatorStyleVoltaSubito
};

@interface MNLPerformanceIndicator : MNLPlaceableStaffItem

@property (nonatomic,assign) MNLPerformanceIndicatorStyle style;

@end
