//
//  NWCPropertyParser.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2014-03-30.
//  Copyright (c) 2014 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FileReader.h"
#import "MNLFontInfo.h"
#import "MNLSong.h"
#import "MNLStaff.h"
#import "MNLFlowDirection.h"
#import "MNLTimeSignature.h"
#import "MNLTempoMarking.h"
#import "MNLSustainPedal.h"
#import "MNLTempoVariance.h"
#import "MNLPerformanceIndicator.h"

// [reader nextUnsignedByte];
// validation: (0, 3, STYLE_PLAIN);
typedef NS_ENUM(NSUInteger, NWCFontInfoStyle) {
    NWCFontInfoStylePlain          = 0x00,
    NWCFontInfoStyleBold           = 0x01,
    NWCFontInfoStyleItalics        = 0x02,
    NWCFontInfoStyleBoldItalics    = 0x03
};

// MS-Windows character set
// http://en.wikipedia.org/wiki/Code_page#Windows_.28ANSI.29_code_pages
// http://support.microsoft.com/kb/165478
/*
 The following table shows the correlation of Charset name, Charset Value and Codepage number:
 Charset Name       Charset Value(hex)  Codepage number
 ------------------------------------------------------
 
 DEFAULT_CHARSET           1 (x01)
 SYMBOL_CHARSET            2 (x02)
 OEM_CHARSET             255 (xFF)
 ANSI_CHARSET              0 (x00)            1252
 RUSSIAN_CHARSET         204 (xCC)            1251
 EE_CHARSET              238 (xEE)            1250
 GREEK_CHARSET           161 (xA1)            1253
 TURKISH_CHARSET         162 (xA2)            1254
 BALTIC_CHARSET          186 (xBA)            1257
 HEBREW_CHARSET          177 (xB1)            1255
 ARABIC _CHARSET         178 (xB2)            1256
 SHIFTJIS_CHARSET        128 (x80)             932
 HANGEUL_CHARSET         129 (x81)             949
 GB2313_CHARSET          134 (x86)             936
 CHINESEBIG5_CHARSET     136 (x88)             950
 */
// [reader nextUnsignedByte];
typedef NS_ENUM(NSUInteger, NWCFontInfoScriptType) {
    NWCFontInfoScriptTypeWindows1250_CentralEuropean   = 0xEE, //238 = -18,
    NWCFontInfoScriptTypeWindows1251_Cyrillic          = 0xCC, //204 = -52,
    NWCFontInfoScriptTypeWindows1252_Western           = 0x00,
    NWCFontInfoScriptTypeWindows1253_Greek             = 0xA1, //161 = -95,
    NWCFontInfoScriptTypeWindows1254_Turkish           = 0xA2, //162 = -94,
    NWCFontInfoScriptTypeWindows1255_Hebrew            = 0xB1, //177 = -79,
    NWCFontInfoScriptTypeWindows1256_Arabic            = 0xB2, //178 = -78,
    NWCFontInfoScriptTypeWindows1257_Baltic            = 0xBA, //186 = -70,
    NWCFontInfoScriptTypeWindows1258_Vietnamese        = 0xA3  //163 = -93
};

typedef NS_ENUM(NSUInteger, NWCAlignSyllable) {
	NWCAlignSyllableNoteStart	= 0, 	// xxxx xx0x = start of accidental/note,
	NWCAlignSyllableStandard	= 2		// xxxx xx1x = standard rules,
};
typedef NS_ENUM(NSUInteger, NWCAlignStaff) {
	NWCAlignStaffBottom     = 0,		// xxxx xxx0 = align bottom
	NWCAlignStaffTop		= 1			// xxxx xxx1 = align top
};
typedef NS_ENUM(NSUInteger, NWCJustify) {
	NWCJustifyLeft		= 0,	// xxxx x00x
	NWCJustifyCenter	= 2,	// xxxx x01x
	NWCJustifyRight     = 4		// xxxx x10x
};
typedef NS_ENUM(NSUInteger, NWCAlign) {
	NWCAlignBestFit                     = 0, // xxx0 0xxx
	NWCAlignBeforeOtherStaffSignatures	= 8, // xxx0 1xxx
	NWCAlignAfterOtherStaffSignatures	= 16,// xxx1 0xxx
	NWCAlignAtNextNote					= 24 // xxx1 1xxx
};
// [reader nextUnsignedByte];
typedef NS_ENUM(NSUInteger, NWCMeasureNumberingStyle) {
	NWCMeasureNumberingStyleNone		= 0,
	NWCMeasureNumberingStylePlain		= 1,
	NWCMeasureNumberingStyleCircled     = 2,
	NWCMeasureNumberingStyleBoxed		= 3
};
// [reader nextUnsignedByte];
typedef NS_ENUM(NSUInteger, NWCStaffLabelPrintStyle) {
	NWCStaffLabelPrintStyleNone         = 0,
	NWCStaffLabelPrintStyleFirstSystem	= 1,
	NWCStaffLabelPrintStyleTopSystem	= 2,
	NWCStaffLabelPrintStyleAllSystems	= 3
};
// [reader nextUnsignedByte];
typedef NS_ENUM(NSUInteger, NWCStaffStyle) {
	NWCStaffStyleStandard				= 0,
	NWCStaffStyleUpperGrandStaff		= 1,
	NWCStaffStyleLowerGrandStaff		= 2,
	NWCStaffStyleOrchestral             = 3
};
// [reader nextUnsignedByte];
typedef NS_ENUM(NSUInteger, NWCEndingBarStyle) {
	NWCEndingBarStyleSectionClose		= 0,
	NWCEndingBarStyleMasterRepeatOpen	= 1,
	NWCEndingBarStyleSingle             = 2,
	NWCEndingBarStyleDouble             = 3,
	NWCEndingBarStyleOpen				= 4
};
typedef NS_ENUM(NSUInteger, NWCStaffItemVisibility) {
	NWCStaffItemVisibilityDefault		= 0,    // xxxx xx00 = Default
	NWCStaffItemVisibilityAlwaysShow	= 1,    // xxxx xx01 = Always show on printed page
	NWCStaffItemVisibilityOnTopStaff	= 2,    // xxxx xx10= Show on top staff
	NWCStaffItemVisibilityNeverShow     = 3     // xxxx xx11 = Never show
};
typedef NS_ENUM(NSUInteger, NWCStaffItemColor) {
	NWCStaffItemColorDefault                = 0, // xxx0 0xxx = Default
	NWCStaffItemColorHighlight1             = 8, // xxx0 1xxx = Highlight 1
	NWCStaffItemColorHighlight2				= 16,// xxx1 0xxx = Highlight 2
	NWCStaffItemColorHighlight3				= 24 // xxx1 1xxx = Highlight 3
};
typedef NS_ENUM(NSUInteger, NWCStaffColor) {
	NWCStaffColorDefault                    = 0, // xxxx xx00 = Default
	NWCStaffColorHighlight1					= 1, // xxxx xx01 = Highlight 1
	NWCStaffColorHighlight2					= 2, // xxxx xx10 = Highlight 2
	NWCStaffColorHighlight3					= 3  // xxxx xx11 = Highlight 3
};
// [reader nextUnsignedByte];
typedef NS_ENUM(NSUInteger, NWCStaffItemType) {
	NWCStaffItemTypeClef					= 0,
	NWCStaffItemTypeKeySignature			= 1,
	NWCStaffItemTypeBarLine                 = 2,
	NWCStaffItemTypeSpecialEnding			= 3,
	NWCStaffItemTypeInstrumentPatch         = 4,
	NWCStaffItemTypeTimeSignature			= 5,
	NWCStaffItemTypeTempoMarking			= 6,
	NWCStaffItemTypeDynamicMarking			= 7,
	NWCStaffItemTypeNote					= 8,
	NWCStaffItemTypeRest					= 9,
	NWCStaffItemTypeCompositeNote			= 10,
	NWCStaffItemTypeSustainPedal			= 11,
	NWCStaffItemTypeFlowDirection			= 12,
	NWCStaffItemTypeMultipointController	= 13,
	NWCStaffItemTypeTempoVariance			= 14,
	NWCStaffItemTypeDynamicVariance         = 15,
	NWCStaffItemTypePerformanceIndicator	= 16,
	NWCStaffItemTypeText					= 17,
	NWCStaffItemTypeCompositeRest           = 18
};
typedef NS_ENUM(NSUInteger, NWCAccidentals) {
	NWCAccidentalsSharp         = 0, // xxxx x000
	NWCAccidentalsFlat			= 1, // xxxx x001
	NWCAccidentalsNatural		= 2, // xxxx x010
	NWCAccidentalsDoubleSharp	= 3, // xxxx x011
	NWCAccidentalsDoubleFlat	= 4, // xxxx x100
	NWCAccidentalsNormal		= 5  // xxxx x101
};
// xxxx x111
typedef NS_ENUM(NSUInteger, NWCTemporalDuration) {
	NWCTemporalDurationWhole			= 0,
	NWCTemporalDurationHalf             = 1,
	NWCTemporalDurationQuarter			= 2,
	NWCTemporalDurationEighth			= 3,
	NWCTemporalDurationSixteenth		= 4,
	NWCTemporalDurationThirtySecondth	= 5,
	NWCTemporalDurationSixtyFourth		= 6
};
// xxxx x1x1
typedef NS_ENUM(NSUInteger, NWCTemporalDurationModifier) {
	NWCTemporalDurationModifierNormal			= 0,
	NWCTemporalDurationModifierDotted			= 4,
	NWCTemporalDurationModifierDoubleDotted     = 1
};
// xxxx x111
typedef NS_ENUM(NSUInteger, NWCBarLineStyle) {
	NWCBarLineStyleSingle				= 0,
	NWCBarLineStyleDouble				= 1,
	NWCBarLineStyleSectionOpen			= 2,
	NWCBarLineStyleSectionClose         = 3,
	NWCBarLineStyleLocalRepeatOpen		= 4,
	NWCBarLineStyleLocalRepeatClose     = 5,
	NWCBarLineStyleMasterRepeatOpen     = 6,
	NWCBarLineStyleMasterRepeatClose	= 7
};
// [reader nextUnsignedByte];
typedef NS_ENUM(NSUInteger, NWCClefType) {
	NWCClefTypeTreble	= 0,
	NWCClefTypeBass     = 1,
	NWCClefTypeAlto     = 2,
	NWCClefTypeTenor	= 3
};
// [reader nextUnsignedByte];
typedef NS_ENUM(NSUInteger, NWCClefOctaveShift) {
	NWCClefOctaveShiftNone	= 0,
	NWCClefOctaveShiftUp	= 1,
	NWCClefOctaveShiftDown	= 2
};
// xxxx x111
typedef NS_ENUM(NSUInteger, NWCDynamicMarkingType) {
	NWCDynamicMarkingTypePPP	= 0,
	NWCDynamicMarkingTypePP     = 1,
	NWCDynamicMarkingTypeP		= 2,
	NWCDynamicMarkingTypeMP     = 3,
	NWCDynamicMarkingTypeMF     = 4,
	NWCDynamicMarkingTypeF		= 5,
	NWCDynamicMarkingTypeFF     = 6,
	NWCDynamicMarkingTypeFFF	= 7
};
typedef NS_ENUM(NSUInteger, NWCDynamicVarianceStyle) {
	NWCDynamicVarianceStyleCrescendo	= 0,
	NWCDynamicVarianceStyleDecrescendo	= 1,
	NWCDynamicVarianceStyleDiminuendo	= 2,
	NWCDynamicVarianceStyleRinforzando	= 3,
	NWCDynamicVarianceStyleSforzando	= 4
};
typedef NS_ENUM(NSUInteger, NWCFlowDirectionStyle) {
	NWCFlowDirectionStyleCoda		= 0,
	NWCFlowDirectionStyleSegno		= 1,
	NWCFlowDirectionStyleFine		= 2,
	NWCFlowDirectionStyleToCoda     = 3,
	NWCFlowDirectionStyleDaCapo     = 4,
	NWCFlowDirectionStyleDCAlCoda	= 5,
	NWCFlowDirectionStyleDCAlFine	= 6,
	NWCFlowDirectionStyleDalSegno	= 7,
	NWCFlowDirectionStyleDSAlCoda	= 8,
	NWCFlowDirectionStyleDSAlFine	= 9
};
// [reader nextUnsignedByte]
typedef NS_ENUM(NSUInteger, NWCPerformanceIndicatorStyle) {
	NWCPerformanceIndicatorStyleAdLibitum		= 0,
	NWCPerformanceIndicatorStyleAnimato         = 1,
	NWCPerformanceIndicatorStyleCantabile		= 2,
	NWCPerformanceIndicatorStyleConBrio         = 3,
	NWCPerformanceIndicatorStyleDolce			= 4,
	NWCPerformanceIndicatorStyleEspressivo		= 5,
	NWCPerformanceIndicatorStyleGrazioso		= 6,
	NWCPerformanceIndicatorStyleLegato			= 7,
	NWCPerformanceIndicatorStyleMaestoso		= 8,
	NWCPerformanceIndicatorStyleMarcato         = 9,
	NWCPerformanceIndicatorStyleMenoMosso		= 10,
	NWCPerformanceIndicatorStylePocoAPoco		= 11,
	NWCPerformanceIndicatorStylePiuMosso		= 12,
	NWCPerformanceIndicatorStyleSemplice		= 13,
	NWCPerformanceIndicatorStyleSimile			= 14,
	NWCPerformanceIndicatorStyleSolo			= 15,
	NWCPerformanceIndicatorStyleSostenuto		= 16,
	NWCPerformanceIndicatorStyleSottoVoce		= 17,
	NWCPerformanceIndicatorStyleStaccato		= 18,
	NWCPerformanceIndicatorStyleSubito			= 19,
	NWCPerformanceIndicatorStyleTenuto			= 20,
	NWCPerformanceIndicatorStyleTutti			= 21,
	NWCPerformanceIndicatorStyleVoltaSubito     = 22
};
// [reader nextUnsignedByte]
typedef NS_ENUM(NSUInteger, NWCSustainPedalStyle) {
	NWCSustainPedalStyleDown		= 0,
	NWCSustainPedalStyleRelease     = 1
};
// [reader nextUnsignedByte]
typedef NS_ENUM(NSUInteger, NWCTempoMarkingBase) {
	NWCTempoMarkingBaseEighth			= 0,
	NWCTempoMarkingBaseDottedEighth     = 1,
	NWCTempoMarkingBaseQuarter			= 2,
	NWCTempoMarkingBaseDottedQuarter	= 3,
	NWCTempoMarkingBaseHalf             = 4,
	NWCTempoMarkingBaseDottedHalf		= 5
};
// [reader nextUnsignedByte]
typedef NS_ENUM(NSUInteger, NWCTempoVarianceType) {
	NWCTempoVarianceTypeBreathMark		= 0,
	NWCTempoVarianceTypeFermata         = 1,
	NWCTempoVarianceTypeAccelerando     = 2,
	NWCTempoVarianceTypeAllargando		= 3,
	NWCTempoVarianceTypeRallentando     = 4,
	NWCTempoVarianceTypeRitardando		= 5,
	NWCTempoVarianceTypeRitenuto		= 6,
	NWCTempoVarianceTypeRubato			= 7,
	NWCTempoVarianceTypeStringendo		= 8
};
// [reader nextUnsignedByte]
typedef NS_ENUM(NSUInteger, NWCTimeSignatureStyle) {
	NWCTimeSignatureStyleStandard		= 0,
	NWCTimeSignatureStyleCommonTime     = 1,
	NWCTimeSignatureStyleAllaBreve		= 2
};


@interface NWCPropertyParser : NSObject


+ (MNLFontInfoStyle)fontInfoStyleFromReader:(FileReader *)reader;
+ (MNLFontInfoScriptType)fontInfoScriptTypeFromReader:(FileReader *)reader;
+ (MNLMeasureNumberingStyle)measureNumberingStyleFromReader:(FileReader *)reader;
+ (MNLStaffLabelPrintStyle)staffLabelsPrintStyleFromReader:(FileReader *)reader;
+ (MNLStaffStyle)staffStyleFromReader:(FileReader *)reader;
+ (MNLEndingBarStyle)endingBarStyleFromReader:(FileReader *)reader;
+ (MNLFlowDirectionStyle)flowDirectionStyleFromReader:(FileReader *)reader;
+ (MNLTimeSignatureStyle)timeSignatureStyleFromReader:(FileReader *)reader;
+ (MNLTempoMarkingBase)tempoMarkingBaseFromReader:(FileReader *)reader;
+ (MNLSustainPedalStyle)sustainPedalStyleFromReader:(FileReader *)reader;
+ (MNLTempoVarianceType)tempoVarianceTypeFromReader:(FileReader *)reader;
+ (MNLPerformanceIndicatorStyle)performanceIndicatorStyleFromReader:(FileReader *)reader;

@end
