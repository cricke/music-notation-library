//
//  NWCParser.m
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-11.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import "NWCParser.h"

#import "NWC.h"
#import "FileReader.h"
#import "NWCStaffItemParser.h"
#import "NWCPropertyParser.h"

#import "MNLFontInfo.h"
#import "MNLStaff.h"
#import "MNLLyrics.h"
#import "MNLLyricsLine.h"
#import "MNLStaffItem.h"

#define MAX_LYRICS_LINE_COUNT 8


@implementation NWCParser

+ (MNLSong *)parseNwcFile:(NSString *)path error:(NSError **)err
{
    FileReader *reader = [FileReader fileReaderWithPath:path error:err];
    if (reader == nil)
        return nil;

    NSString *fileDef = [reader nextNullTerminatedString];
    if ([fileDef isEqualToString:@""])
    {
        if (err)
            *err = MNLMakeError(MNLErrorCode_UnrecognizedFileFormat, NSLocalizedString(@"Unrecognized file format", @"NSError description"), nil);
        return nil;
    }

    if ([fileDef isEqualToString:@"[NWZ]"])
    {
        NSLog(@"Parsing compressed NWC file...");
        if (![reader inflateWithError:err])
            return nil;
        
        fileDef = [reader nextNullTerminatedString];
    }
    
    //NSLog(@"%@",fileDef);
    if (![fileDef isEqualToString:@"[NoteWorthy ArtWare]"])
    {
        //NSLog(@"NOTE: Unexpected editor name: '%@' Expected: '[NoteWorthy ArtWare]'", fileDef); // Always: "[NoteWorthy ArtWare]"
        if (err)
            *err = MNLMakeError(MNLErrorCode_UnrecognizedFileFormat, NSLocalizedString(@"Unrecognized file format", @"NSError description"), nil);
        return nil;
    }
    
    @try {
        return [self songFromReader:reader];
    }
    @catch (NSException *exception) {
        NSLog(@"WARN: Caught excpetion: %@", exception);
        if (err)
            *err = MNLMakeError(MNLErrorCode_ParseError, NSLocalizedString(@"Unrecognized file format", @"NSError description"), exception.reason);
        return nil;
    }
}

+ (MNLSong *)songFromReader:(FileReader *)reader
{
    MNLSong *song = [[MNLSong alloc] init];
    
    [reader skipBytes:2]; // Always: "0,0"
    
    NSString *editorName = [reader nextNullTerminatedString]; // Always: "[NoteWorthy Composer]"
    NSLog(@"%@",editorName);
    //if (!editorName.equals("[NoteWorthy Composer]"))
    //    NSLog(@"NOTE: Unexpected editor name: '" + editorName + "' Expected: '[NoteWorthy Composer]'");
    
    [reader skipBytes:6];
    // buf[0] - seems to change with the version number, but it's not what NW use to determine if a file can be parsed
    // buf[4] - changes on each save (numTimesSaved)
    
    NSString *registeredUsername = [reader nextNullTerminatedString]; // The name to which NW was registered, or N/A for unregistered?
    NSLog(@"%@",registeredUsername);
    
    NSString *checksum = [reader nextNullTerminatedString]; // String changes on each save, checksum?
    NSLog(@"%@",checksum);
    
    [reader skipBytes:8];
    
    int nwFileFormatVersion = [reader nextUnsignedByte];
    switch (nwFileFormatVersion) {
        case NW_VERSION_COMMON:
        case NW_VERSION_LEGACY:
        case NW_VERSION_LEGACY_2:
            NSLog(@"nwFileFormatVersion = %d",nwFileFormatVersion);
            break; // Supported versions
            
        default:
            NSLog(@"WARN: Unrecognized and possibly unsupported NWC file format version: %d. Will still try to parse.", nwFileFormatVersion);
            break;
    }
    [reader skipBytes:1];
    
    
    song.name = [reader nextNullTerminatedString];
    song.author = [reader nextNullTerminatedString]; //TODO: If empty, use registeredUsername?
    
    NSArray *copyrightNotices = [[NSArray alloc] initWithObjects:
                                 [reader nextNullTerminatedString],
                                 [reader nextNullTerminatedString],
                                 nil];
    song.copyrightNotices = copyrightNotices;
    
    song.comments = [reader nextNullTerminatedString];
    
    song.lastSystemExtended = [reader nextYNBoolean];
    song.spacingIncreasedWithLongerNotes = [reader nextYNBoolean];
    [reader skipBytes:5];
    
    song.measureNumberingStyle = [NWCPropertyParser measureNumberingStyleFromReader:reader];
    
    [reader skipBytes:1];
    
    song.measureNumberingStart = validate([reader nextSignedShort], 0, 1000, 1, @"measureNumberingStart");
    //NSLog(@"measureNumberingStart = %d",song.measureNumberingStart);
 
    // Page margins
    NSString *marginsStr = [reader nextNullTerminatedString];
    NSLog(@"Page margins: %@", marginsStr);
    NSArray *margins = [marginsStr componentsSeparatedByString:@" "];
    if ([margins count] == 4)
    {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        nf.decimalSeparator = @".";
        song.pageMarginTop = [[nf numberFromString:[margins objectAtIndex:0]] doubleValue];
        song.pageMarginInside = [[nf numberFromString:[margins objectAtIndex:1]] doubleValue];
        song.pageMarginOutside = [[nf numberFromString:[margins objectAtIndex:2]] doubleValue];
        song.pageMarginBottom = [[nf numberFromString:[margins objectAtIndex:3]] doubleValue];
    }
    else
    {
        // Non-fatal error
        NSLog(@"WARN: Ignoring unrecognized page margins: %@", marginsStr);
    }

    // "Unit" (cm or inches) is not saved in the file
    
    song.mirrorMargins = [reader nextBoolean];
    [reader skipBytes:2];
    
    // "Visible Groups" in NW is not stored in file, but calculated based on which staves are visible
    //TODO: Since we're saving this in staff.visible, maybe we don't have to persist visibleStavesByIndex?
    song.visibleStavesByIndex = [reader nextBooleanArray:32];
    
    song.layeringAllowed = [reader nextBoolean]; // OFF=0, ON=255
    song.staffSize = validate([reader nextUnsignedByte], 4, 40, 12, @"staffSize");
    [reader skipBytes:1];
    
    // Font info
    NSMutableArray *fonts = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i=0; i< 10; i++)
        [fonts addObject:[self fontInfoFromReader:reader]];
    
    if (nwFileFormatVersion >= NW_VERSION_LEGACY)
    {
        [fonts addObject:[self fontInfoFromReader:reader]];
        [fonts addObject:[self fontInfoFromReader:reader]];
    }
    song.fonts = fonts;
    
    
    song.titlePageInfo = [reader nextBoolean]; // OFF=0, ON=255
    song.staffLabelsPrintStyle = [NWCPropertyParser staffLabelsPrintStyleFromReader:reader];
    
    int pNum = validate([reader nextSignedShort], 0, 1000, 0, @"pageNumberingFrom"); // 0=OFF, 1-1000 value
    song.pageNumberingEnabled = (pNum != 0);
    if (song.pageNumberingEnabled)
        song.pageNumberingFrom = pNum; // MIN: 1, MAX: 10000
    else
        song.pageNumberingFrom = 1; // Default value
    
    // If bounds check fail here, we cannot recover...
    int numStaves = [reader nextSignedShort];
    //NSLog(@"Song contains " + numStaves + " staves");
    if ((numStaves < 0) || (numStaves > 255))
    {
        // NW allows maximum 255 staves (0-254)
        // It seems it can show maximum 64 staves in the work area (window), hides the rest...
        NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"Song cannot contain %d staves", @"NSException reason"), numStaves];
        @throw [NSException exceptionWithName:MNLParseException reason:reason userInfo:nil];
    }
    
    //NSLog(@"numStaves: %d", numStaves);
    
    NSMutableArray *staves = [[NSMutableArray alloc] initWithCapacity:numStaves];
    for (int i=0; i<numStaves; i++)
    {
        MNLStaff *staff = [self staffFromReader:reader usingNWFileFormat:nwFileFormatVersion];
        staff.visible = song.visibleStavesByIndex[i];
        [staves addObject:staff];
    }
    song.staves = staves;


    // Stream should now be empty!
    if (![reader isEof])
    {
        // Non-fatal error
        NSLog(@"WARN: File has more data than expected");
    }
    
    return song;
}

+ (MNLFontInfo *)fontInfoFromReader:(FileReader *)reader
{
    MNLFontInfo *font = [[MNLFontInfo alloc] init];
    
    font.name = [reader nextNullTerminatedString];
    //NSLog(@"Font: %@", font.name);
    
#if OUTPUT_PARSER_DEBUG_FONT
    NSLog(@"Font info: %@ %@", font.name, [reader peek:4]);
#endif

    font.style = [NWCPropertyParser fontInfoStyleFromReader:reader];
    
    font.size = validate([reader nextUnsignedShort], 0, 65535, 8, @"font size");
    // Actually, NWC-16 is really buggy here, you can enter any number -9999 to 99999,
    // but regardless what is says, it will only save values in range 0-65535
    // When entering -9999 => -9998 or 2
    // Also, the default font size varies per font
    
    font.scriptType = [NWCPropertyParser fontInfoScriptTypeFromReader:reader];
    
    return font;
}

+ (MNLStaff *)staffFromReader:(FileReader *)reader usingNWFileFormat:(NSUInteger)nwVersion
{
    MNLStaff *staff = [[MNLStaff alloc] init];
    
    staff.name = [reader nextNullTerminatedString];
    staff.groupName = [reader nextNullTerminatedString];
    NSLog(@">----------------------------------<");
    NSLog(@"Staff name: %@", staff.name);
    
    
#if OUTPUT_PARSER_DEBUG_STAFF
    NSUInteger infoLen;
    if (nwVersion >= NW_VERSION_COMMON)
        infoLen = 29; // reads bytes 0-28
    else if (nwVersion >= NW_VERSION_LEGACY)
        infoLen = 28; // reads bytes 0-27
    else
        infoLen = 27; // reads bytes 0-26
    NSLog(@"Staff info: %@", [reader peek:infoLen]);
#endif
    
    staff.endingBarStyle = [NWCPropertyParser endingBarStyleFromReader:reader];
    
    staff.muted = [reader nextBoolean]; //buf[1]
    [reader skipBytes:1];
    staff.channelNumber = validate([reader nextUnsignedByte], 0, 15, 1, @"channel number"); // buf[3];
    [reader skipBytes:1];
    staff.playbackDeviceIndex = validate([reader nextUnsignedByte], 0, 15, 0, @"playbackDeviceIndex"); // buf[5];
    [reader skipBytes:1];
    staff.patchBankSelected = [reader nextBoolean]; // ((buf[7] & 1) == 1);
    [reader skipBytes:1];
    staff.soundBank = validate([reader nextSignedShort], 0, 16383, 0, @"patch bank"); // buf[9], buf[10];
    
    staff.instrumentPatchIndex = validate([reader nextUnsignedByte], 0, 127, 0, @"instrument patch index"); // buf[11];
    [reader skipBytes:1];
    
    //TODO: Constraint: Members of a Grand Staff must use 5 lines per staff
    staff.style = [NWCPropertyParser staffStyleFromReader:reader];
    [reader skipBytes:1];
    
    // NWC has 12 as standard (compared to our 5) - that's why we divide by 2.4
    staff.upperHeight = -validate([reader nextSignedShort], -100, -1, -12, @"staff upper height"); // buf[15], buf[16]
    staff.lowerHeight = validate([reader nextSignedShort], 1, 100, 12, @"staff lower height"); // buf[17], buf[18]
    
    if (nwVersion >= NW_VERSION_COMMON)
        staff.numStaffLines = validate([reader nextUnsignedByte], 0, 32, 5, @"num staff lines"); // buf[19];
    
    staff.layeredWithNextStaff = [reader nextBoolean]; // ((buf[20] & 1) == 1);
    
    [reader skipBytes:1];
    
    staff.transposition = validate([reader nextSignedShort], -24, 24, 0, @"transposition"); // buf[22, 23];
    staff.partVolume = validate([reader nextSignedByte], -1, 127, 127, @"part volume"); // buf[24];
    [reader skipBytes:1];
    staff.stereoPan = validate([reader nextSignedByte], -1, 127, 64, @"stereo pan"); // buf[26];
    [reader skipBytes:1];
    
    if (nwVersion >= NW_VERSION_LEGACY)
    {
        // Color:
        // xxxx xx00 = Default
        // xxxx xx01 = Highlight 1
        // xxxx xx10 = Highlight 2
        // xxxx xx11 = Highlight 3
        // validate: 0, 3, COLOR_DEFAULT); // buf[28];
        NSUInteger buf = [reader nextUnsignedByte];
        int maskedValue = (buf & 3);    // xxxxxx11
        switch (maskedValue) {
            case NWCStaffColorDefault:     staff.color = MNLColorDefault; break;
            case NWCStaffColorHighlight1:  staff.color = MNLColorHighlight1; break;
            case NWCStaffColorHighlight2:  staff.color = MNLColorHighlight2; break;
            case NWCStaffColorHighlight3:  staff.color = MNLColorHighlight3; break;
            default:
                // This can never happen
                NSLog(@"WARN: Unrecognized staff color: '%lu & 3' => '%d' Defaulting to MNLColorDefault",(unsigned long)buf,maskedValue);
                staff.color = MNLColorDefault;
        }
    }
    
    staff.lyrics = [self lyricsFromReader:reader];
    
    int numItems = [reader nextSignedShort] - 2; //TODO: "-2" WTF?!?
    NSLog(@"Staff contains %d objects", numItems);
    
    if (numItems < 0)
    {
        // Fatal error...
        NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"Staff cannot contain %d objects", @"NSException reason"), numItems];
        @throw [NSException exceptionWithName:MNLParseException reason:reason userInfo:nil];
    }
    
    NSMutableArray *staffItems = [[NSMutableArray alloc] initWithCapacity:numItems];
    for (int i=0; i<numItems; i++)
    {
        //NSLog(@"%d: ",i);
        MNLStaffItem *item = [NWCStaffItemParser staffItemFromReader:reader usingNWFileFormat:nwVersion];
        if (item != nil)
            [staffItems addObject:item];
    }
    staff.items = staffItems;
    
    return staff;
}


+ (MNLLyrics *)lyricsFromReader:(FileReader *)reader
{
    // The first 6 bytes are ALWAYS THERE, regardless if there are lyrics or not
    
#if OUTPUT_PARSER_DEBUG_LYRICS
    NSLog(@"Lyrics info: %@", [reader peek:6]);
#endif
    
    bool hasLyrics = [reader nextBoolean]; // buf[0] == 1;
    if (!hasLyrics) // No lyrics
    {
        NSLog(@"Staff has no lyrics");
        [reader skipBytes:5];
        return nil;
    }
    
    MNLLyrics *lyrics = [[MNLLyrics alloc] init];
    
    [reader skipBytes:1]; //buf[1]
    
    int lyricsLineCount = [reader nextUnsignedByte]; // buf[2];
    if ((lyricsLineCount < 0) || (lyricsLineCount > MAX_LYRICS_LINE_COUNT))
    {
        // OutOfBounds are fatal...
        NSString *reason = [NSString stringWithFormat:NSLocalizedString(@"Staff cannot have %d lyric lines", @"NSException reason"), lyricsLineCount];
        @throw [NSException exceptionWithName:MNLParseException reason:reason userInfo:nil];
    }
    
    [reader skipBytes:1]; //buf[3]
    
    int temp = [reader nextUnsignedByte];
    lyrics.alignSyllable = [self syllableAlignmentForUnsignedByte:temp];
    lyrics.alignStaff = [self staffAlignmentForUnsignedByte:temp];
    
    [reader skipBytes:1]; //buf[5]
    
    NSLog(@"The staff has %d lyric lines", lyricsLineCount);
    
#if OUTPUT_PARSER_DEBUG_LYRICS
    NSLog(@"Extra: %@", [reader peek:3]);
#endif
    lyrics.verticalOffset = validate([reader nextSignedShort], -100, 100, 0, @"vertical offset");
    
    [reader skipBytes:1];
    
    
    NSMutableArray *lyricLines = [[NSMutableArray alloc] initWithCapacity:lyricsLineCount];
    for (int i=0; i<lyricsLineCount; i++)
    {
        [lyricLines addObject:[self lyricsLineFromReader:reader]];
    }
    lyrics.lines = lyricLines;
    
#if OUTPUT_PARSER_DEBUG_LYRICS
    NSLog(@"Extra: %@", [reader peek:3]);
#endif
    [reader skipBytes:3];
    
    return lyrics;
}
+ (MNLLyricsLine *)lyricsLineFromReader:(FileReader *)reader
{
    MNLLyricsLine *line = [[MNLLyricsLine alloc] init];
    
#if OUTPUT_PARSER_DEBUG_LYRICS
    NSLog(@"lyricsLineFromReader: numBlocks (nextSignedShortFunky): %@", [reader peek:2]);
#endif
    int numBlocks = validate([reader nextSignedShortFunky], 0, SHRT_MAX, 0, @"num lyrics blocks");
    if (numBlocks == 0)
    {
        NSLog(@"Empty lyrics line");
        return line;
    }
    
    
#if OUTPUT_PARSER_DEBUG_LYRICS
    //NSLog(@"lyricsLineFromReader: numBlocks (Extra): %@", [reader peek:3]+2);
    NSLog(@"lyricsLineFromReader: Extra: %@", [reader peek:3]);
#endif
    [reader skipBytes:3];
    
    
    // If we have lyrics, there's always at least one 1024 block (maybe more)
    // The first 6 bytes are meta info, meaning 1018 bytes of lyric text
    
    
    NSLog(@"Lyrics line has %d blocks", numBlocks);
    
    //NSLog(@"Remaining bytes: " + countBytes(input));
    
    int blockSize = 1024;
    int firstBlockSize = 1020; //1018
    int bytesToRead = blockSize * (numBlocks-1) + firstBlockSize;

#if OUTPUT_PARSER_DEBUG_LYRICS
    NSLog(@"Block 1: %@", [reader peek:firstBlockSize]);
    int peekOffset = firstBlockSize;
    for (int i=1; i<numBlocks; i++) {
        NSLog(@"Block %d: %@", i+1, [reader peek:blockSize offset:peekOffset]);
        peekOffset += blockSize;
    }
#endif
    
    line.syllables = [reader nextNullTerminatedStrings:bytesToRead];
    
    //NSLog(@"Lyrics syllables: %@",line.syllables);
    
    
#if OUTPUT_PARSER_DEBUG_LYRICS
    NSLog(@"lyricsLineFromReader: Extra: %@", [reader peek:3]);
#endif
    [reader skipBytes:3];
    
    return line;
}





#pragma mark - option readers
+ (MNLSyllableAlignment)syllableAlignmentForUnsignedByte:(int)ubyte
{
    // xxxx xx0x = start of accidental/note,
    // xxxx xx1x = standard rules,
    int maskedValue = (ubyte & 0x02);
    switch (maskedValue) {
        case NWCAlignSyllableNoteStart: return MNLSyllableAlignmentNoteStart;
        case NWCAlignSyllableStandard:  return MNLSyllableAlignmentStandard;
        default:
            // Can never happen
            NSLog(@"WARN: Unrecognized syllable alignment: '%d & 0x02' => '%d' Defaulting to MNLSyllableAlignmentStandard",ubyte,maskedValue);
            return MNLSyllableAlignmentStandard;
    }
}
+ (MNLStaffAlignment)staffAlignmentForUnsignedByte:(int)ubyte
{
    // xxxx xxx0 = align bottom
    // xxxx xxx1 = align top
    int maskedValue = (ubyte & 0x01);
    switch (maskedValue) {
        case NWCAlignStaffBottom:   return MNLStaffAlignmentBottom;
        case NWCAlignStaffTop:      return MNLStaffAlignmentTop;
        default:
            // Can never happen
            NSLog(@"WARN: Unrecognized staff alignment: '%d & 0x01' => '%d' Defaulting to MNLStaffAlignmentTop",ubyte,maskedValue);
            return MNLStaffAlignmentTop;
    }
}






@end
