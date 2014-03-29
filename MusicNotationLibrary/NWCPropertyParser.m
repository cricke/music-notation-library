//
//  NWCPropertyParser.m
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2014-03-30.
//  Copyright (c) 2014 Cinus. All rights reserved.
//

#import "NWCPropertyParser.h"


@implementation NWCPropertyParser


#pragma mark - enum readers
+ (MNLFontInfoStyle)fontInfoStyleFromReader:(FileReader *)reader
{
    NSUInteger style = [reader nextUnsignedByte];
    switch (style) {
        case NWCFontInfoStylePlain:         return MNLFontInfoStylePlain;
        case NWCFontInfoStyleBold:          return MNLFontInfoStyleBold;
        case NWCFontInfoStyleItalics:       return MNLFontInfoStyleItalics;
        case NWCFontInfoStyleBoldItalics:   return MNLFontInfoStyleBoldItalics;
        default:
            NSLog(@"WARN: Unrecognized style: '%lu' Defaulting to MNLFontInfoStylePlain", (unsigned long)style);
            return MNLFontInfoStylePlain;
    }
}
+ (MNLFontInfoScriptType)fontInfoScriptTypeFromReader:(FileReader *)reader
{
    NSUInteger scriptType = [reader nextUnsignedByte];
    switch (scriptType) {
        case NWCFontInfoScriptTypeWindows1250_CentralEuropean:  return MNLFontInfoScriptTypeWindows1250_CentralEuropean;
        case NWCFontInfoScriptTypeWindows1251_Cyrillic:         return MNLFontInfoScriptTypeWindows1251_Cyrillic;
        case NWCFontInfoScriptTypeWindows1252_Western:          return MNLFontInfoScriptTypeWindows1252_Western;
        case NWCFontInfoScriptTypeWindows1253_Greek:            return MNLFontInfoScriptTypeWindows1253_Greek;
        case NWCFontInfoScriptTypeWindows1254_Turkish:          return MNLFontInfoScriptTypeWindows1254_Turkish;
        case NWCFontInfoScriptTypeWindows1255_Hebrew:           return MNLFontInfoScriptTypeWindows1255_Hebrew;
        case NWCFontInfoScriptTypeWindows1256_Arabic:           return MNLFontInfoScriptTypeWindows1256_Arabic;
        case NWCFontInfoScriptTypeWindows1257_Baltic:           return MNLFontInfoScriptTypeWindows1257_Baltic;
        case NWCFontInfoScriptTypeWindows1258_Vietnamese:       return MNLFontInfoScriptTypeWindows1258_Vietnamese;
        default:
            NSLog(@"WARN: Unrecognized scriptType: '%lu' Defaulting to MNLFontInfoScriptTypeWindows1252_Western", (unsigned long)scriptType);
            return MNLFontInfoScriptTypeWindows1252_Western;
    }
}
+ (MNLMeasureNumberingStyle)measureNumberingStyleFromReader:(FileReader *)reader
{
    // validate: readUnsignedByte(0, 3, MEASURE_NUMBERING_STYLE_NONE);
    // 0=NONE, 1=PLAIN, 2=CIRCLED, 3=BOXED
    NSUInteger measureNumberingStyle = [reader nextUnsignedByte];
    switch (measureNumberingStyle) {
        case NWCMeasureNumberingStyleNone:      return MNLMeasureNumberingStyleNone;
        case NWCMeasureNumberingStylePlain:     return MNLMeasureNumberingStylePlain;
        case NWCMeasureNumberingStyleCircled:   return MNLMeasureNumberingStyleCircled;
        case NWCMeasureNumberingStyleBoxed:     return MNLMeasureNumberingStyleBoxed;
        default:
            NSLog(@"WARN: Unrecognized measureNumberingStyle: '%lu' Defaulting to MNLMeasureNumberingStyleNone", (unsigned long)measureNumberingStyle);
            return MNLMeasureNumberingStyleNone;
    }
}
+ (MNLStaffLabelPrintStyle)staffLabelsPrintStyleFromReader:(FileReader *)reader
{
    // Validate: (0, 3, STAFF_LABEL_PRINT_STYLE_NONE);
    NSUInteger staffLabelsPrintStyle = [reader nextUnsignedByte];
    switch (staffLabelsPrintStyle) {
        case NWCStaffLabelPrintStyleNone:           return MNLStaffLabelPrintStyleNone;
        case NWCStaffLabelPrintStyleFirstSystem:    return MNLStaffLabelPrintStyleFirstSystem;
        case NWCStaffLabelPrintStyleTopSystem:      return MNLStaffLabelPrintStyleTopSystem;
        case NWCStaffLabelPrintStyleAllSystems:     return MNLStaffLabelPrintStyleAllSystems;
        default:
            NSLog(@"WARN: Unrecognized staffLabelsPrintStyle: '%lu' Defaulting to MNLStaffLabelPrintStyleNone", (unsigned long)staffLabelsPrintStyle);
            return MNLStaffLabelPrintStyleNone;
    }
}
+ (MNLStaffStyle)staffStyleFromReader:(FileReader *)reader
{
    // Validate: 0, 3, STYLE_STANDARD); // (buf[13] & 0x03);
    NSUInteger style = [reader nextUnsignedByte];
    switch (style) {
        case NWCStaffStyleStandard:         return MNLStaffStyleStandard;
        case NWCStaffStyleUpperGrandStaff:  return MNLStaffStyleUpperGrandStaff;
        case NWCStaffStyleLowerGrandStaff:  return MNLStaffStyleLowerGrandStaff;
        case NWCStaffStyleOrchestral:       return MNLStaffStyleOrchestral;
        default:
            NSLog(@"WARN: Unrecognized staff style: '%lu' Defaulting to MNLStaffStyleStandard", (unsigned long)style);
            return MNLStaffStyleStandard;
    }
}
+ (MNLEndingBarStyle)endingBarStyleFromReader:(FileReader *)reader
{
    // Validate: 0, 4, SECTION_CLOSE); // buf[0];
    NSUInteger endingBarStyle = [reader nextUnsignedByte];
    switch (endingBarStyle) {
        case NWCEndingBarStyleSectionClose:     return MNLEndingBarStyleSectionClose;
        case NWCEndingBarStyleMasterRepeatOpen: return MNLEndingBarStyleMasterRepeatOpen;
        case NWCEndingBarStyleSingle:           return MNLEndingBarStyleSingle;
        case NWCEndingBarStyleDouble:           return MNLEndingBarStyleDouble;
        case NWCEndingBarStyleOpen:             return MNLEndingBarStyleOpen;
        default:
            NSLog(@"WARN: Unrecognized ending bar style: '%lu' Defaulting to MNLEndingBarStyleSectionClose", (unsigned long)endingBarStyle);
            return MNLEndingBarStyleSectionClose;
    }
}
+ (MNLFlowDirectionStyle)flowDirectionStyleFromReader:(FileReader *)reader
{
    // validate: (0, 9, CODA);
    NSUInteger flowDirectionStyle = [reader nextUnsignedByte];
    switch (flowDirectionStyle) {
        case NWCFlowDirectionStyleCoda:     return MNLFlowDirectionStyleCoda;
        case NWCFlowDirectionStyleSegno:	return MNLFlowDirectionStyleSegno;
        case NWCFlowDirectionStyleFine:		return MNLFlowDirectionStyleFine;
        case NWCFlowDirectionStyleToCoda:   return MNLFlowDirectionStyleToCoda;
        case NWCFlowDirectionStyleDaCapo:   return MNLFlowDirectionStyleDaCapo;
        case NWCFlowDirectionStyleDCAlCoda:	return MNLFlowDirectionStyleDCAlCoda;
        case NWCFlowDirectionStyleDCAlFine:	return MNLFlowDirectionStyleDCAlFine;
        case NWCFlowDirectionStyleDalSegno:	return MNLFlowDirectionStyleDalSegno;
        case NWCFlowDirectionStyleDSAlCoda:	return MNLFlowDirectionStyleDSAlCoda;
        case NWCFlowDirectionStyleDSAlFine:	return MNLFlowDirectionStyleDSAlFine;
        default:
            NSLog(@"WARN: Unrecognized flow direction style: '%lu' Defaulting to MNLFlowDirectionStyleCoda", (unsigned long)flowDirectionStyle);
            return MNLFlowDirectionStyleCoda;
    }
}
+ (MNLTimeSignatureStyle)timeSignatureStyleFromReader:(FileReader *)reader
{
    int intValue = [reader nextUnsignedByte];
    switch (intValue) {
        case NWCTimeSignatureStyleStandard:     return MNLTimeSignatureStyleStandard;
        case NWCTimeSignatureStyleCommonTime:   return MNLTimeSignatureStyleCommonTime;
        case NWCTimeSignatureStyleAllaBreve:    return MNLTimeSignatureStyleAllaBreve;
        default:
            NSLog(@"WARN: Unrecognized time signature style: '%d' Defaulting to MNLTimeSignatureStyleStandard", intValue);
            return MNLTimeSignatureStyleStandard;
    }
}
+ (MNLTempoMarkingBase)tempoMarkingBaseFromReader:(FileReader *)reader
{
    int intValue = [reader nextUnsignedByte];
    switch (intValue) {
        case NWCTempoMarkingBaseEighth:         return MNLTempoMarkingBaseEighth;
        case NWCTempoMarkingBaseDottedEighth:   return MNLTempoMarkingBaseDottedEighth;
        case NWCTempoMarkingBaseQuarter:        return MNLTempoMarkingBaseQuarter;
        case NWCTempoMarkingBaseDottedQuarter:  return MNLTempoMarkingBaseDottedQuarter;
        case NWCTempoMarkingBaseHalf:           return MNLTempoMarkingBaseHalf;
        case NWCTempoMarkingBaseDottedHalf:     return MNLTempoMarkingBaseDottedHalf;
        default:
            NSLog(@"WARN: Unrecognized time signature style: '%d' Defaulting to MNLTempoMarkingBaseQuarter", intValue);
            return MNLTempoMarkingBaseQuarter;
    }
}
+ (MNLSustainPedalStyle)sustainPedalStyleFromReader:(FileReader *)reader
{
    int intValue = [reader nextUnsignedByte];
    switch (intValue) {
        case NWCSustainPedalStyleDown:      return MNLSustainPedalStyleDown;
        case NWCSustainPedalStyleRelease:   return MNLSustainPedalStyleRelease;
        default:
            NSLog(@"WARN: Unrecognized sustain pedal style: '%d' Defaulting to MNLSustainPedalStyleDown", intValue);
            return MNLSustainPedalStyleDown;
    }
}
+ (MNLTempoVarianceType)tempoVarianceTypeFromReader:(FileReader *)reader
{
    int intValue = [reader nextUnsignedByte];
    switch (intValue) {
        case NWCTempoVarianceTypeBreathMark:    return MNLTempoVarianceTypeBreathMark;
        case NWCTempoVarianceTypeFermata:       return MNLTempoVarianceTypeFermata;
        case NWCTempoVarianceTypeAccelerando:   return MNLTempoVarianceTypeAccelerando;
        case NWCTempoVarianceTypeAllargando:    return MNLTempoVarianceTypeAllargando;
        case NWCTempoVarianceTypeRallentando:   return MNLTempoVarianceTypeRallentando;
        case NWCTempoVarianceTypeRitardando:    return MNLTempoVarianceTypeRitardando;
        case NWCTempoVarianceTypeRitenuto:      return MNLTempoVarianceTypeRitenuto;
        case NWCTempoVarianceTypeRubato:        return MNLTempoVarianceTypeRubato;
        case NWCTempoVarianceTypeStringendo:    return MNLTempoVarianceTypeStringendo;
        default:
            NSLog(@"WARN: Unrecognized tempo variance style: '%d' Defaulting to MNLTempoVarianceTypeBreathMark", intValue);
            return MNLTempoVarianceTypeBreathMark;
    }
}
+ (MNLPerformanceIndicatorStyle)performanceIndicatorStyleFromReader:(FileReader *)reader
{
    int intValue = [reader nextUnsignedByte];
    switch (intValue) {
        case NWCPerformanceIndicatorStyleAdLibitum:     return MNLPerformanceIndicatorStyleAdLibitum;
        case NWCPerformanceIndicatorStyleAnimato:       return MNLPerformanceIndicatorStyleAnimato;
        case NWCPerformanceIndicatorStyleCantabile:     return MNLPerformanceIndicatorStyleCantabile;
        case NWCPerformanceIndicatorStyleConBrio:       return MNLPerformanceIndicatorStyleConBrio;
        case NWCPerformanceIndicatorStyleDolce:         return MNLPerformanceIndicatorStyleDolce;
        case NWCPerformanceIndicatorStyleEspressivo:    return MNLPerformanceIndicatorStyleEspressivo;
        case NWCPerformanceIndicatorStyleGrazioso:      return MNLPerformanceIndicatorStyleGrazioso;
        case NWCPerformanceIndicatorStyleLegato:        return MNLPerformanceIndicatorStyleLegato;
        case NWCPerformanceIndicatorStyleMaestoso:      return MNLPerformanceIndicatorStyleMaestoso;
        case NWCPerformanceIndicatorStyleMarcato:       return MNLPerformanceIndicatorStyleMarcato;
        case NWCPerformanceIndicatorStyleMenoMosso:     return MNLPerformanceIndicatorStyleMenoMosso;
        case NWCPerformanceIndicatorStylePocoAPoco:     return MNLPerformanceIndicatorStylePocoAPoco;
        case NWCPerformanceIndicatorStylePiuMosso:      return MNLPerformanceIndicatorStylePiuMosso;
        case NWCPerformanceIndicatorStyleSemplice:      return MNLPerformanceIndicatorStyleSemplice;
        case NWCPerformanceIndicatorStyleSimile:        return MNLPerformanceIndicatorStyleSimile;
        case NWCPerformanceIndicatorStyleSolo:          return MNLPerformanceIndicatorStyleSolo;
        case NWCPerformanceIndicatorStyleSostenuto:     return MNLPerformanceIndicatorStyleSostenuto;
        case NWCPerformanceIndicatorStyleSottoVoce:     return MNLPerformanceIndicatorStyleSottoVoce;
        case NWCPerformanceIndicatorStyleStaccato:      return MNLPerformanceIndicatorStyleStaccato;
        case NWCPerformanceIndicatorStyleSubito:        return MNLPerformanceIndicatorStyleSubito;
        case NWCPerformanceIndicatorStyleTenuto:        return MNLPerformanceIndicatorStyleTenuto;
        case NWCPerformanceIndicatorStyleTutti:         return MNLPerformanceIndicatorStyleTutti;
        case NWCPerformanceIndicatorStyleVoltaSubito:   return MNLPerformanceIndicatorStyleVoltaSubito;
        default:
            NSLog(@"WARN: Unrecognized performance indicator style: '%d' Defaulting to MNLPerformanceIndicatorStyleAdLibitum", intValue);
            return MNLPerformanceIndicatorStyleAdLibitum;
    }
}

@end
