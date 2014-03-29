//
//  NWCStaffItemParser.m
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2014-03-30.
//  Copyright (c) 2014 Cinus. All rights reserved.
//

#import "NWCStaffItemParser.h"

#import "NWC.h"
#import "NWCPropertyParser.h"
#import "MNLClef.h"
#import "MNLKeySignature.h"
#import "MNLBarLine.h"
#import "MNLSpecialEnding.h"
#import "MNLInstrumentPatch.h"
#import "MNLTimeSignature.h"
#import "MNLTempoMarking.h"
#import "MNLDynamicMarking.h"
#import "MNLNote.h"
#import "MNLRest.h"
#import "MNLCompositeNote.h"
#import "MNLSustainPedal.h"
#import "MNLFlowDirection.h"
#import "MNLMultipointController.h"
#import "MNLTempoVariance.h"
#import "MNLDynamicVariance.h"
#import "MNLPerformanceIndicator.h"
#import "MNLText.h"
#import "MNLCompositeRest.h"

@implementation NWCStaffItemParser



+ (MNLStaffItem *)staffItemFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
    NWCStaffItemType itemType = [reader nextUnsignedByte];
    switch (itemType)
    {
        case NWCStaffItemTypeClef:                 return [NWCStaffItemParser clefFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeKeySignature:         return [NWCStaffItemParser keySignatureFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeBarLine:              return [NWCStaffItemParser barLineFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeSpecialEnding:        return [NWCStaffItemParser specialEndingFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeInstrumentPatch:      return [NWCStaffItemParser instrumentPatchFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeTimeSignature:        return [NWCStaffItemParser timeSignatureFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeTempoMarking:         return [NWCStaffItemParser tempoMarkingFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeDynamicMarking:       return [NWCStaffItemParser dynamicMarkingFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeNote:                 return [NWCStaffItemParser noteFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeRest:                 return [NWCStaffItemParser restFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeCompositeNote:        return [NWCStaffItemParser compositeNoteFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeSustainPedal:         return [NWCStaffItemParser sustainPedalFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeFlowDirection:        return [NWCStaffItemParser flowDirectionFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeMultipointController: return [NWCStaffItemParser multipointControllerFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeTempoVariance:        return [NWCStaffItemParser tempoVarianceFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeDynamicVariance:      return [NWCStaffItemParser dynamicVarianceFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypePerformanceIndicator: return [NWCStaffItemParser performanceIndicatorFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeText:                 return [NWCStaffItemParser textFromReader:reader usingNWFileFormat:nwVersion];
        case NWCStaffItemTypeCompositeRest:        return [NWCStaffItemParser compositeRestFromReader:reader usingNWFileFormat:nwVersion];
            
        default:
        {
            // Unrecoverable error
            NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"Unexpected NWCStaffItemType: %d", @"NSException reason"), itemType];
            @throw [NSException exceptionWithName:MNLParseException reason:reason userInfo:nil];
        }
    }
}


#pragma mark - NWCStaffItems

+ (MNLStaffItem *)clefFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 6;
    else
        numBytes = 5;
    NSLog(@"CLEF: 0,%@", [reader peek:numBytes]);
#endif
    
    MNLClef *clef = [[MNLClef alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:clef fromReader:reader]; //buf[1]
    
    
    NSUInteger buf = [reader nextUnsignedByte]; // buf[2]
    int maskedValue = (buf & 3);    // xxxx xx11
    switch (maskedValue) {
        case NWCClefTypeTreble:     clef.type = MNLClefTypeTreble; break;
        case NWCClefTypeBass:       clef.type = MNLClefTypeBass; break;
        case NWCClefTypeAlto:       clef.type = MNLClefTypeAlto; break;
        case NWCClefTypeTenor:      clef.type = MNLClefTypeTenor; break;
        default:
            // This can never happen
            NSLog(@"WARN: Unrecognized clef type: '%lu & 3' => '%d' Defaulting to NWCClefTypeTreble",(unsigned long)buf,maskedValue);
            clef.type = MNLClefTypeTreble;
    }
    
    [reader skipBytes:1]; // buf[3]
    
    buf = [reader nextUnsignedByte]; // buf[4]
    maskedValue = (buf & 3);    // xxxx xx11
    switch (maskedValue) {
        case NWCClefOctaveShiftNone:     clef.octaveShift = MNLClefOctaveShiftNone; break;
        case NWCClefOctaveShiftUp:       clef.octaveShift = MNLClefOctaveShiftUp; break;
        case NWCClefOctaveShiftDown:     clef.octaveShift = MNLClefOctaveShiftDown; break;
        default:
            NSLog(@"WARN: Unrecognized octave shift: '%lu & 3' => '%d' Defaulting to MNLClefOctaveShiftNone",(unsigned long)buf,maskedValue);
            clef.octaveShift = MNLClefOctaveShiftNone;
    }
    
    [reader skipBytes:1]; // buf[5]
    
    return clef;
}
+ (MNLStaffItem *)keySignatureFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 12;
    else
        numBytes = 11;
    NSLog(@"KEY: 1,%@", [reader peek:numBytes]);
#endif
    
    MNLKeySignature *key = [[MNLKeySignature alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:key fromReader:reader]; // buf[1]
    
    int f = [reader nextUnsignedByte]; //buf[2]
    int flats[] = {(f >> 2) & 1, (f >> 3) & 1, (f >> 4) & 1, (f >> 5) & 1, (f >> 6) & 1, (f >> 0) & 1, (f >> 1) & 1};
    
    [reader skipBytes:1]; // buf[3]
    
    int s = [reader nextUnsignedByte]; //buf[4]
    int sharps[] = {(s >> 2) & 1, (s >> 3) & 1, (s >> 4) & 1, (s >> 5) & 1, (s >> 6) & 1, (s >> 0) & 1, (s >> 1) & 1};
    
    for (int j=0; j< 7; j++)
    {
        if (flats[j] != 0)
            key.keymodifier[j] = MNLAccidentalsFlat;
        else if (sharps[j] != 0)
            key.keymodifier[j] = MNLAccidentalsSharp;
    }
    
    [reader skipBytes:7]; //TODO: buf 5,6,7,8,9,10,11
    
    return key;
}
+ (MNLStaffItem *)barLineFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 4;
    else
        numBytes = 3;
    NSLog(@"BARLINE: 2,%@", [reader peek:numBytes]);
#endif
    
    MNLBarLine *barline = [[MNLBarLine alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:barline fromReader:reader]; // buf[1]
    
    int buf = [reader nextUnsignedByte]; // buf[2]
    
    int maskedValue = (buf & 7); // xxxx x111
    switch (maskedValue) {
        case NWCBarLineStyleSingle:             barline.barStyle = MNLBarLineStyleSingle; break;
        case NWCBarLineStyleDouble:             barline.barStyle = MNLBarLineStyleDouble; break;
        case NWCBarLineStyleSectionOpen:        barline.barStyle = MNLBarLineStyleSectionOpen; break;
        case NWCBarLineStyleSectionClose:       barline.barStyle = MNLBarLineStyleSectionClose; break;
        case NWCBarLineStyleLocalRepeatOpen:    barline.barStyle = MNLBarLineStyleLocalRepeatOpen; break;
        case NWCBarLineStyleLocalRepeatClose:   barline.barStyle = MNLBarLineStyleLocalRepeatClose; break;
        case NWCBarLineStyleMasterRepeatOpen:   barline.barStyle = MNLBarLineStyleMasterRepeatOpen; break;
        case NWCBarLineStyleMasterRepeatClose:  barline.barStyle = MNLBarLineStyleMasterRepeatClose; break;
        default:
            NSLog(@"WARN: Unrecognized bar style: '%d & 7' => '%d' Defaulting to MNLBarLineStyleSingle",buf,maskedValue);
            barline.barStyle = MNLBarLineStyleSingle;
            break;
    }
    
    barline.forceSystemBreak = ((buf & 128) == 128);    // 1xxx xxxx
    
    // NW allows 2-250 with LOCAL_REPEAT_CLOSE
    barline.repeatCount = validate([reader nextUnsignedByte], 1, 250, 1, @"repeat count"); // buf[3]
    
    return barline;
}
+ (MNLStaffItem *)specialEndingFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 4;
    else
        numBytes = 3;
    NSLog(@"SPECIAL ENDING: 3,%@", [reader peek:numBytes]);
#endif
    
    MNLSpecialEnding *ending = [[MNLSpecialEnding alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:ending fromReader:reader]; // buf[1]
    
    //TODO:
    //ending.endingFlags = reader.readBooleanArray(1); //buf[2] which ending it is: D765 4321
    [reader skipBytes:1];
    
    [reader skipBytes:1]; // buf[3]
    
    return ending;
}
+ (MNLStaffItem *)instrumentPatchFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 10;
    else
        numBytes = 9;
    NSLog(@"INSTRUMENT PATCH: 4,%@", [reader peek:numBytes]);
#endif
    
    MNLInstrumentPatch *patch = [[MNLInstrumentPatch alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:patch fromReader:reader]; // buf[1]
    
    [self parsePlacement:patch fromReader:reader]; //buf[2], buf[3]
    
    [reader skipBytes:6]; //TODO: bytes 4,5,6,7,8,9
    
    return patch;
}
+ (MNLStaffItem *)timeSignatureFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 8;
    else
        numBytes = 7;
    NSLog(@"TIME: 5,%@", [reader peek:numBytes]);
#endif
    
    MNLTimeSignature *timesig = [[MNLTimeSignature alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:timesig fromReader:reader]; // buf[1]
    
    // numerator
    timesig.beatsPerMinute = validate([reader nextUnsignedByte], 1, 99, 4, @"beats per minute"); //buf[2]
    [reader skipBytes:1]; // buf[3]
    
    timesig.beatValue = [self parseBeatValueFromReader:reader]; // buf[4]
    [reader skipBytes:1]; // buf[5]
    
    timesig.style = [NWCPropertyParser timeSignatureStyleFromReader:reader]; //buf[6]
    [reader skipBytes:1]; // buf[7]
    
    return timesig;
}
+ (MNLStaffItem *)tempoMarkingFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes = 7;
    //tempo._buf = reader.peek(7);
    NSLog(@"TEMPO: 6,%@", [reader peek:numBytes]);
#endif
    
    MNLTempoMarking *tempo = [[MNLTempoMarking alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:tempo fromReader:reader]; // buf[1]
    
    [self parsePlacement:tempo fromReader:reader]; // buf[2], buf[3]
    
    tempo.bpm = validate([reader nextSignedShort], 20, 750, 120, @"bpm"); // buf[5], buf[4]
    tempo.base = [NWCPropertyParser tempoMarkingBaseFromReader:reader]; // buf[6]
    
    if (nwVersion < NW_VERSION_LEGACY)
        [reader skipBytes:1]; //buf[7]
    
    tempo.text = [reader nextNullTerminatedString];
    
    return tempo;
}
+ (MNLStaffItem *)dynamicMarkingFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 9;
    else
        numBytes = 8;
    NSLog(@"DYNAMIC: 7,%@", [reader peek:numBytes]);
#endif
    
    MNLDynamicMarking *dyn = [[MNLDynamicMarking alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:dyn fromReader:reader]; // buf[1]
    
    [self parsePlacement:dyn fromReader:reader]; // buf[2], buf[3]
    
    int buf = [reader nextUnsignedByte]; // buf[4]
    int maskedValue = (buf & 7);    // xxxx x111
    switch (maskedValue) {
        case NWCDynamicMarkingTypePPP:  dyn.dynamic = NWCDynamicMarkingTypePPP; break;
        case NWCDynamicMarkingTypePP:   dyn.dynamic = NWCDynamicMarkingTypePP; break;
        case NWCDynamicMarkingTypeP:    dyn.dynamic = NWCDynamicMarkingTypeP; break;
        case NWCDynamicMarkingTypeMP:   dyn.dynamic = NWCDynamicMarkingTypeMP; break;
        case NWCDynamicMarkingTypeMF:   dyn.dynamic = NWCDynamicMarkingTypeMF; break;
        case NWCDynamicMarkingTypeF:    dyn.dynamic = NWCDynamicMarkingTypeF; break;
        case NWCDynamicMarkingTypeFF:   dyn.dynamic = NWCDynamicMarkingTypeFF; break;
        case NWCDynamicMarkingTypeFFF:  dyn.dynamic = NWCDynamicMarkingTypeFFF; break;
        default:
            // This can never happen
            NSLog(@"WARN: Unrecognized dynamic: '%lu & 7' => '%d' Defaulting to NWCDynamicMarkingTypeMF",(unsigned long)buf,maskedValue);
            dyn.dynamic = NWCDynamicMarkingTypeMF;
    }
    
    dyn.overrideNoteVelocity = ((buf & 32) == 32);      // xx1x xxxx
    dyn.overrideMidiVolume = ((buf & 64) == 64);        // x1xx xxxx
    
    dyn.defaultNoteVelocity = validate([reader nextUnsignedByte], 0, 127, 60, @"default note velocity"); // buf[5]
    [reader skipBytes:1]; // buf[6]
    
    dyn.defaultMidiVolume = validate([reader nextSignedShort], -1, 127, -1, @"default MIDI volume"); // buf[7], buf[8]
    
    return dyn;
}
+ (MNLStaffItem *)noteFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM_NOTE
    int numBytes;
    if (nwVersion >= NW_VERSION_COMMON)
        numBytes = 10;
    else if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 12;
    else
        numBytes = 11;
    NSLog(@"NOTE: 8,%@", [reader peek:numBytes]);
#endif
    
    MNLNote *note = [[MNLNote alloc] init];
    [self parseNote:note fromReader:reader usingNWFileFormat:nwVersion];
    return note;
}
+ (MNLStaffItem *)restFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 10;
    else
        numBytes = 9;
    NSLog(@"REST: 9,%@", [reader peek:numBytes]);
#endif
    
    MNLRest *rest = [[MNLRest alloc] init];
    [self parseTemporalStaffItem:rest fromReader:reader usingNWFileFormat:nwVersion]; // buf[0...7]
    [reader skipBytes:2]; //TODO: bytes 8,9
    return rest;
}
+ (MNLStaffItem *)compositeNoteFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_COMMON)
        numBytes = 12; //10+2
    else if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 16; //12+2
    else
        numBytes = 15; //11+2
    NSLog(@"COMPOSITE: 10,%@", [reader peek:numBytes]);
#endif
    
    MNLCompositeNote *composite = [[MNLCompositeNote alloc] init];
    
    // CompositeNotes have the exact same first (10 | 12 | 11) bytes as a regular Note + 2 extra trailing bytes
    // except tieInfo in buf[6]
    [self parseCompositeNote:composite fromReader:reader usingNWFileFormat:nwVersion];
    
    
    if (nwVersion < NW_VERSION_COMMON)
        [reader skipBytes:2]; //TODO: Bytes 12,13 ??
    
    
    int numItems = [reader nextUnsignedByte]; // buf[10] | buf[14] | buf[13]
    
    [reader skipBytes:1]; // buf[15]
    
    NSMutableArray *subitems = [[NSMutableArray alloc] initWithCapacity:numItems];
    for (int j=0; j<numItems; j++)
    {
        MNLStaffItem *item = [self staffItemFromReader:reader usingNWFileFormat:nwVersion];
        [subitems addObject:item];
    }
    composite.components = subitems;
    
    return composite;
}
+ (MNLStaffItem *)sustainPedalFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 5;
    else
        numBytes = 4;
    NSLog(@"SUSTAIN PEDAL: 11,%@", [reader peek:numBytes]);
#endif
    
    MNLSustainPedal *pedal = [[MNLSustainPedal alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:pedal fromReader:reader]; // buf[1]
    
    [self parsePlacement:pedal fromReader:reader]; // buf[2], buf[3]
    
    pedal.style = [NWCPropertyParser sustainPedalStyleFromReader:reader]; // buf[4]
    
    return pedal;
}
+ (MNLStaffItem *)flowDirectionFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 6;
    else
        numBytes = 5;
    NSLog(@"FLOW DIRECTION: 12,%@", [reader peek:numBytes]);
#endif
    
    MNLFlowDirection *flow = [[MNLFlowDirection alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:flow fromReader:reader]; // buf[1]
    
    [self parsePlacement:flow fromReader:reader]; //buf[2], buf[3]
    
    flow.style = [NWCPropertyParser flowDirectionStyleFromReader:reader]; //buf[4]
    [reader skipBytes:1]; // buf[5]
    
    return flow;
}
+ (MNLStaffItem *)multipointControllerFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 36;
    else
        numBytes = 35;
    NSLog(@"MPC: 13,%@", [reader peek:numBytes]);
#endif
    
    MNLMultipointController *mpc = [[MNLMultipointController alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:mpc fromReader:reader]; //buf[1]
    
    [self parsePlacement:mpc fromReader:reader]; //buf[2], buf[3]
    
    [reader skipBytes:32]; //TODO: bytes: 4-35
    
    return mpc;
}
+ (MNLStaffItem *)tempoVarianceFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 6;
    else
        numBytes = 5;
    NSLog(@"TEMPO VARIANCE: 14,%@", [reader peek:numBytes]);
#endif
    
    MNLTempoVariance *variance = [[MNLTempoVariance alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:variance fromReader:reader]; //buf[1]
    
    [self parsePlacement:variance fromReader:reader]; //buf[2], buf[3]
    
    variance.type = [NWCPropertyParser tempoVarianceTypeFromReader:reader]; // buf[4]
    variance.delay = validate([reader nextUnsignedByte], 0, 64, 0, @"delay"); // buf[5]
    
    return variance;
}
+ (MNLStaffItem *)dynamicVarianceFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 5;
    else
        numBytes = 4;
    NSLog(@"DYNAMIC VARIANCE: 15,%@", [reader peek:numBytes]);
#endif
    
    MNLDynamicVariance *dyn = [[MNLDynamicVariance alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:dyn fromReader:reader]; // buf[1]
    
    [self parsePlacement:dyn fromReader:reader]; //buf[2], buf[3]
    
    int buf = [reader nextUnsignedByte]; //buf[4]
    switch (buf) {
        case NWCDynamicVarianceStyleCrescendo:      dyn.style = MNLDynamicVarianceStyleCrescendo; break;
        case NWCDynamicVarianceStyleDecrescendo:    dyn.style = MNLDynamicVarianceStyleDecrescendo; break;
        case NWCDynamicVarianceStyleDiminuendo:     dyn.style = MNLDynamicVarianceStyleDiminuendo; break;
        case NWCDynamicVarianceStyleRinforzando:    dyn.style = MNLDynamicVarianceStyleRinforzando; break;
        case NWCDynamicVarianceStyleSforzando:      dyn.style = MNLDynamicVarianceStyleSforzando; break;
        default:
            NSLog(@"WARN: Unrecognized dynamic variance style: '%d' Defaulting to NWCDynamicVarianceStyleCrescendo",buf);
            dyn.style = NWCDynamicVarianceStyleCrescendo;
    }
    
    return dyn;
}
+ (MNLStaffItem *)performanceIndicatorFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 5;
    else
        numBytes = 4;
    NSLog(@"PERFORMANCE: 16,%@", [reader peek:numBytes]);
#endif
    
    MNLPerformanceIndicator *indicator = [[MNLPerformanceIndicator alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:indicator fromReader:reader]; // buf[1]
    
    [self parsePlacement:indicator fromReader:reader]; //buf[2], buf[3]
    
    indicator.style = [NWCPropertyParser performanceIndicatorStyleFromReader:reader]; // buf[4]
    
    return indicator;
}
+ (MNLStaffItem *)textFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 5;
    else
        numBytes = 3;
    NSLog(@"TEXT: 17,%@", [reader peek:numBytes]);
#endif
    
    MNLText *text = [[MNLText alloc] init];
    [reader skipBytes:1]; // buf[0]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:text fromReader:reader]; //buf[1]
    
    [self parsePlacement:text fromReader:reader]; //buf[2], buf[3]
    
    if (nwVersion >= NW_VERSION_LEGACY)
        text.fontId = validate([reader nextUnsignedByte], 0, 11, 0, @"font id"); // buf[4]
    
    text.text = [reader nextNullTerminatedString];
    
    return text;
}
+ (MNLStaffItem *)compositeRestFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
#if OUTPUT_PARSER_DEBUG_STAFFITEM
    int numBytes;
    if (nwVersion >= NW_VERSION_LEGACY)
        numBytes = 12;
    else
        numBytes = 11;
    NSLog(@"COMPOSITE REST: 18,%@", [reader peek:numBytes]);
#endif
    
    MNLCompositeRest *composite = [[MNLCompositeRest alloc] init];
    // CompositeRests have the exact same first 10 bytes as a regular Rest + 2 extra trailing bytes
    [self parseTemporalStaffItem:composite fromReader:reader usingNWFileFormat:nwVersion]; //buf[0...7]
    [reader skipBytes:2]; //TODO: bytes 8,9
    
    // This will always be 1 - either a Note or a CompositeNote
    int numItems = validate([reader nextUnsignedByte], 1, 1, 1, @"num items"); // buf[10]
    [reader skipBytes:1]; //TODO: buf[11]
    
    NSMutableArray *subitems = [[NSMutableArray alloc] initWithCapacity:numItems];
    for (int j=0; j<numItems; j++)
    {
        MNLStaffItem *item = [self staffItemFromReader:reader usingNWFileFormat:nwVersion];
        [subitems addObject:item];
    }
    composite.components = subitems;
    
    return composite;
}


#pragma mark - Helpers
+ (void)parseVisibility:(MNLStaffItem *)item fromReader:(FileReader *)reader
{
    int buf = [reader nextUnsignedByte];
    
    // Visibility:
    // xxxx xx00 = Default
    // xxxx xx01 = Always show on printed page
    // xxxx xx10= Show on top staff
    // xxxx xx11 = Never show
    int maskedValue = buf & 3;    // xxxxxx11
    switch (maskedValue) {
        case NWCStaffItemVisibilityDefault:     item.visibility = MNLStaffItemVisibilityDefault; break;
        case NWCStaffItemVisibilityAlwaysShow:  item.visibility = MNLStaffItemVisibilityAlwaysShow; break;
        case NWCStaffItemVisibilityOnTopStaff:  item.visibility = MNLStaffItemVisibilityOnTopStaff; break;
        case NWCStaffItemVisibilityNeverShow:   item.visibility = MNLStaffItemVisibilityNeverShow; break;
        default:
            // This can never happen
            NSLog(@"WARN: Unrecognized visibility: '%d & 0x03' => '%d' Defaulting to MNLStaffItemVisibilityDefault",buf,maskedValue);
            item.visibility = MNLStaffItemVisibilityDefault;
    }
    
    // Color:
    // xxx0 0xxx = Default
    // xxx0 1xxx = Highlight 1
    // xxx1 0xxx = Highlight 2
    // xxx1 1xxx = Highlight 3
    maskedValue = (buf & 24);    // xxx11xxx
    switch (maskedValue) {
        case NWCStaffItemColorDefault:     item.color = MNLColorDefault; break;
        case NWCStaffItemColorHighlight1:  item.color = MNLColorHighlight1; break;
        case NWCStaffItemColorHighlight2:  item.color = MNLColorHighlight2; break;
        case NWCStaffItemColorHighlight3:  item.color = MNLColorHighlight3; break;
        default:
            // This can never happen
            NSLog(@"WARN: Unrecognized staff item color: '%d & 24' => '%d' Defaulting to MNLStaffItemColorDefault",buf,maskedValue);
            item.color = MNLColorDefault;
    }
}
+ (void)parsePlacement:(MNLPlaceableStaffItem *)item fromReader:(FileReader *)reader
{
    item.staffPosition = validate([reader nextSignedByte], -100, 100, 0, @"staff position"); //buf[2]
    
    int buf = [reader nextUnsignedByte]; //buf[3]
    item.preserveWidth = ((buf & 0x01) == 1);    // xxxx xxx1
    
    int maskedValue = (buf & 0x06);            // xxxx x11x
    switch (maskedValue) {
        case NWCJustifyLeft:    item.justification = MNLPlaceableStaffItemJustifyLeft; break;
        case NWCJustifyCenter:  item.justification = MNLPlaceableStaffItemJustifyCenter; break;
        case NWCJustifyRight:   item.justification = MNLPlaceableStaffItemJustifyRight; break;
        default:
            NSLog(@"WARN: Unrecognized justification: '%d & 0x06' => '%d' Defaulting to MNLJustifyLeft",buf,maskedValue);
            item.justification = MNLPlaceableStaffItemJustifyLeft;
    }
    
    maskedValue = buf & 24;                    // xxx1 1xxx
    switch (maskedValue) {
        case NWCAlignBestFit:                       item.alignment = MNLPlaceableStaffItemAlignBestFit; break;
        case NWCAlignBeforeOtherStaffSignatures:    item.alignment = MNLPlaceableStaffItemAlignBeforeOtherStaffSignatures; break;
        case NWCAlignAfterOtherStaffSignatures:     item.alignment = MNLPlaceableStaffItemAlignAfterOtherStaffSignatures; break;
        case NWCAlignAtNextNote:                    item.alignment = MNLPlaceableStaffItemAlignAtNextNote; break;
        default:
            NSLog(@"WARN: Unrecognized alignment: '%d & 0x24' => '%d' Defaulting to MNLPlaceableStaffItemAlignBestFit",buf,maskedValue);
            item.alignment = MNLPlaceableStaffItemAlignBestFit;
    }
}
+ (int)parseDuration:(MNLTemporalStaffItem *)item fromReader:(FileReader *)reader
{
    int buf = [reader nextUnsignedByte];
    //TODO: validate: (0x00, 0xFF, 0);
    
    
    int maskedValue = buf & 7;    // xxxx x111
    switch (maskedValue) {
        case NWCTemporalDurationWhole:          item.duration = MNLTemporalDurationWhole; break;
        case NWCTemporalDurationHalf:           item.duration = MNLTemporalDurationHalf; break;
        case NWCTemporalDurationQuarter:        item.duration = MNLTemporalDurationQuarter; break;
        case NWCTemporalDurationEighth:         item.duration = MNLTemporalDurationEighth; break;
        case NWCTemporalDurationSixteenth:      item.duration = MNLTemporalDurationSixteenth; break;
        case NWCTemporalDurationThirtySecondth: item.duration = MNLTemporalDurationThirtySecondth; break;
        case NWCTemporalDurationSixtyFourth:    item.duration = MNLTemporalDurationSixtyFourth; break;
            
        default:
            NSLog(@"WARN: Unrecognized duration: '%d & 7' => '%d' Defaulting to MNLTemporalDurationWhole",buf,maskedValue);
            item.duration = MNLTemporalDurationWhole;
    }
    
    
    
    
    item.extraAccidentalSpacing = (buf & 112) >> 4;    // x111 xxxx
    
    return buf;
}
+ (int)parseNoteSpacing:(MNLTemporalStaffItem *)item fromReader:(FileReader *)reader
{
    int buf = [reader nextUnsignedByte];
    //TODO: validate: (0x00, 0xFF, 0);
    item.extraNoteSpacing = buf & 3;                // xxxx xx11 (0-3)
    return buf;
}
+ (int)parseGrouping:(MNLTemporalStaffItem *)item fromReader:(FileReader *)reader
{
    int buf = [reader nextUnsignedByte]; //buf[4]
    
    switch (buf & 3) // xxxx xx11
    {
        case 1: item.beamInfo = MNLBeamInfoBeamedWithNext; break;
        case 2: item.beamInfo = MNLBeamInfoBeamedWithBoth; break;
        case 3: item.beamInfo = MNLBeamInfoBeamedWithPrevious; break;
        case 0:
        default: item.beamInfo = MNLBeamInfoNone; break;
    }
    
    switch (buf & 12) // xxxx 11xx
    {
        case 4:
        case 8:
        case 12: item.tupletGrouping = MNLTupletInfoTriplet; break;
        case 0:
        default: item.tupletGrouping = MNLTupletInfoNone; break;
    }
    
    switch (buf & 48) // xx11 xxxx
    {
        case 16: item.stemDirection = MNLStemDirectionUp; break;
        case 32: item.stemDirection = MNLStemDirectionDown; break;
        case 0:
        case 48:
        default: item.stemDirection = MNLStemDirectionAuto; break;
    }
    
    // only valid if (buf[7] & 128) == 128
    switch (buf & 64) { // x1xx xxxx
        case 0:     item.slurDirection = MNLSlurDirectionUpward; break;  // x0xx xxxx
        case 64:    item.slurDirection = MNLSlurDirectionDownward; break;  // x1xx xxxx
        default:    break; // Not possible
    }
    
    
    // Weird setup for lyricsSyllabel
    item.lyricsSyllable = MNLLyricsSyllableDefault;
    
    if ((buf & 128) == 128)    // 1xxx xxxx
        item.lyricsSyllable = MNLLyricsSyllableAlways;
    
    
    return buf;
}
+ (int)parseLyrics:(MNLTemporalStaffItem *)item fromReader:(FileReader *)reader
{
    int buf = [reader nextUnsignedByte];
    //TODO: validate: (0x00, 0xFF, 0);
    
    if ((buf & 1) == 1) // xxxx xxx1
        item.lyricsSyllable = MNLLyricsSyllableNever;
    
    return buf;
}
+ (int)parseDurationModifier:(MNLTemporalStaffItem *)item fromReader:(FileReader *)reader
{
    int buf = [reader nextUnsignedByte];
    //TODO: validate: (0x00, 0xFF, 0);
    
    item.staccato = ((buf & 2) == 2); // xxxx xx1x
    
    int maskedValue = buf & 5; // xxxx x1x1
    switch (maskedValue)
    {
        case NWCTemporalDurationModifierDoubleDotted:
            item.durationModifier = MNLTemporalDurationModifierDoubleDotted; break;
        case NWCTemporalDurationModifierDotted:
            item.durationModifier = MNLTemporalDurationModifierDotted; break;
        case NWCTemporalDurationModifierNormal:
            item.durationModifier = MNLTemporalDurationModifierNormal; break;
        default:
            NSLog(@"WARN: Unrecognized duration modifier: '%d & 5' => '%d' Defaulting to MNLTemporalDurationModifierNormal",buf,maskedValue);
            item.durationModifier = MNLTemporalDurationModifierNormal; break;
    }
    
    item.accent = ((buf & 32) == 32); // xx1x xxxx
    
    return buf;
}
+ (int)parseSlur:(MNLTemporalStaffItem *)item fromReader:(FileReader *)reader
{
    //TODO: masked read?
    int buf = [reader nextUnsignedByte];
    
    // xxxx xx00 = no slur
    // xxxx xx01 = first slur
    // xxxx xx11 = middle slur
    // xxxx xx10 = last slur
    switch (buf & 3) // xxxx xx11
    {
        case 1: item.slurInfo = MNLSlurInfoBeamedWithNext; break;
        case 2: item.slurInfo = MNLSlurInfoBeamedWithPrevious; break;
        case 3: item.slurInfo = MNLSlurInfoBeamedWithBoth; break;
        case 0:
        default: item.slurInfo = MNLSlurInfoNone; break;
    }
    
    // xxxx x1xx = tenuto
    item.tenuto = ((buf & 0x04) == 4);
    // xx1x xxxx = grace note
    item.graceNote = ((buf & 32) == 32);
    
    // x1xx xxxx = tie direction is specified
    item.tieDirectionEnabled = ((buf & 64) == 64);
    // Dealt with in [NWCParser parseNote:fromReader:usingNWFileFormat]
    
    // 1xxx xxxx = slur direction is specified
    item.slurDirectionEnabled = ((buf & 128) == 128);
    if (!item.slurDirectionEnabled)
        item.slurDirection = MNLSlurDirectionDefault;
    
    //TODO: slur direction, tie direction
    return buf;
}

+ (int)parseBeatValueFromReader:(FileReader *)reader
{
    int buf = [reader nextUnsignedByte];
    //TODO: validate: (0, 5, -1);
    switch(buf)
    {
        case 0: return 1;
        case 1: return 2;
        case 2: return 4;
        case 3: return 8;
        case 4: return 16;
        case 5: return 32;
        default:
        {
            NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"Illegal beat value: %d", @"NSException reason"), buf];
            @throw [NSException exceptionWithName:MNLParseException reason:reason userInfo:nil];
        }
    }
}
+ (void)parseTemporalStaffItem:(MNLTemporalStaffItem *)item fromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
    [reader skipBytes:1]; //TODO: Byte 0??
    
    if (nwVersion >= NW_VERSION_LEGACY)
        [self parseVisibility:item fromReader:reader]; //buf[1]
    
    [self parseDuration:item fromReader:reader]; //buf[2]
    [self parseNoteSpacing:item fromReader:reader]; //buf[3]
    [self parseGrouping:item fromReader:reader]; //buf[4]
    [self parseLyrics:item fromReader:reader]; //buf[5]
    [self parseDurationModifier:item fromReader:reader]; //buf[6]
    [self parseSlur:item fromReader:reader]; //buf[7]
}

+ (void)parseNote:(MNLNote *)note fromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
    [self parseTemporalStaffItem:note fromReader:reader usingNWFileFormat:nwVersion]; //buf[0...7]
    
    // NW allows -100 to 100
    note.noteValue = [reader nextSignedByte];
    //TODO: validate: (-127, 127, 0); //buf[8]
    
    int buf = [reader nextUnsignedByte];
    //TODO: validate: (0x00, 0xFF, 0); //buf[9]
    
    int maskedValue = buf & 7;            // xxxx x111
    switch (maskedValue) {
        case NWCAccidentalsSharp:       note.toneModifier = MNLAccidentalsSharp; break;
        case NWCAccidentalsFlat:        note.toneModifier = MNLAccidentalsFlat; break;
        case NWCAccidentalsNatural:     note.toneModifier = MNLAccidentalsNatural; break;
        case NWCAccidentalsDoubleSharp: note.toneModifier = MNLAccidentalsDoubleSharp; break;
        case NWCAccidentalsDoubleFlat:  note.toneModifier = MNLAccidentalsDoubleFlat; break;
        case NWCAccidentalsNormal:      note.toneModifier = MNLAccidentalsNormal; break;
        default:
            NSLog(@"WARN: Unrecognized accidental: '%d & 7' => '%d' Defaulting to MNLAccidentalsNormal",buf,maskedValue);
            note.toneModifier = MNLAccidentalsNormal;
    }
    
    
    // xxxx 1xxx // only valid if (buf[7] & 64) == 64 //TODO: also parse in rests, composites?
    if (note.tieDirectionEnabled && ((buf & 8) == 8)) // xxxx 1xxx
        note.tieDirection = MNLTieDirectionDownward;
    else if (note.tieDirectionEnabled && ((buf & 8) == 0)) // xxxx 0xxx
        note.tieDirection = MNLTieDirectionUpward;
    else
        note.tieDirection = MNLTieDirectionDefault;
    
    
    note.muted = ((buf & 16) == 16);        // xxx1 xxxx
    note.withoutLegerLines = ((buf & 32) == 32);    // xx1x xxxx
    
    if (nwVersion >= NW_VERSION_COMMON)
        return;
    
    [reader skipBytes:2]; //TODO: Bytes 10, 11??
}
+ (void)parseCompositeNote:(MNLCompositeNote *)note fromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
    [self parseTemporalStaffItem:note fromReader:reader usingNWFileFormat:nwVersion]; //buf[0...7]
    
    // noteValue, toneModifier, tieDirection, muted, withoutLegerLines doesn't make sense for composite notes (on the group level)
    [reader skipBytes:2]; //TODO: bytes 8,9
    
    if (nwVersion >= NW_VERSION_COMMON)
        return;
    
    [reader skipBytes:2]; //TODO: Bytes 10, 11??
}
+ (void)parseCompositeRest:(MNLCompositeRest *)rest fromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
    [self parseTemporalStaffItem:rest fromReader:reader usingNWFileFormat:nwVersion]; //buf[0...7]
    [reader skipBytes:2]; //TODO: bytes 8,9
}



@end
