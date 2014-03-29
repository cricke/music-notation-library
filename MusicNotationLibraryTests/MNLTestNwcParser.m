//
//  MNLTestNwcParser.m
//  MusicNotationLibraryTests
//
//  Created by Christian O. Andersson on 2014-01-26.
//  Copyright (c) 2014 Cinus. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NWCParser.h"
#import "MNLStaff.h"
#import "MNLFontInfo.h"
#import "MNLNote.h"
#import "MNLLyricsLine.h"

@interface MNLNwcParserTests : XCTestCase
@property (nonatomic) MNLSong *song;
@end

@implementation MNLNwcParserTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSString *)pathForNwcFilename:(NSString *)nwcFilename
{
    NSString *path = [[NSBundle bundleForClass:[self class]] bundlePath];
    path = [path stringByAppendingPathComponent:@"nwc-16"];
    //NSLog(@"bundlePath: %@", path);

    return [path stringByAppendingPathComponent:nwcFilename];
}

- (void)open:(NSString *)nwcFilename
{
    NSError *err = nil;
    NSString *path = [self pathForNwcFilename:nwcFilename];
    self.song = [NWCParser parseNwcFile:path error:&err];
    XCTAssertNotNil(self.song);
    XCTAssertNil(err);
}


- (void)testFileDoesNotExist
{
    // Non-existant file, corrupted etc
    NSError *err = nil;
    MNLSong *song = [NWCParser parseNwcFile:@"this-file-does-not-exist" error:&err];
    XCTAssertNil(song);
    XCTAssertNotNil(err);
}

- (void)testFileIsEmpty
{
    NSError *err = nil;
    NSString *path = [self pathForNwcFilename:@"testEmptyFile.nwc"];
    MNLSong *song = [NWCParser parseNwcFile:path error:&err];
    XCTAssertNil(song);
    XCTAssertNotNil(err);
}

- (void)testFileIsNotNwc
{
    NSError *err = nil;
    NSString *path = [self pathForNwcFilename:@"testFileIsNotNwc.nwc"];
    MNLSong *song = [NWCParser parseNwcFile:path error:&err];
    XCTAssertNil(song);
    XCTAssertNotNil(err);
}

- (void)testCorruptedFileUninflatable
{
    NSError *err = nil;
    NSString *path = [self pathForNwcFilename:@"testCorruptedFileUninflatable.nwc"];
    MNLSong *song = [NWCParser parseNwcFile:path error:&err];
    XCTAssertNil(song);
    XCTAssertNotNil(err);
}

- (void)testCorruptedFileUnrecognizedStaffItem
{
    NSError *err = nil;
    NSString *path = [self pathForNwcFilename:@"testCorruptedFileUnrecognizedStaffItem.nwc"];
    MNLSong *song = [NWCParser parseNwcFile:path error:&err];
    XCTAssertNil(song);
    XCTAssertNotNil(err);
}

- (void)testNewBlankScore
{
    [self open:@"testNewBlankScore.nwc"];

    // "File info"
    XCTAssertEqualObjects(self.song.name, @"");
    XCTAssertEqualObjects(self.song.author, @"NoteWorthy Composer");
    NSArray *notices = @[@"Copyright © 2014 NoteWorthy Software, Inc.", @"All Rights Reserved"];
    XCTAssertEqualObjects(self.song.copyrightNotices, notices);
    XCTAssertEqualObjects(self.song.comments, @"");

    // "Page Setup > Contents"
    NSMutableArray *vSBI = [NSMutableArray arrayWithObject:@(YES)];
    for (int i=1; i<256; i++)
        vSBI[i] = @(NO);
    XCTAssertEqualObjects(self.song.visibleStavesByIndex, vSBI);
    XCTAssertTrue(self.song.layeringAllowed);

    // "Page Setup" > "Options"
    XCTAssertFalse(self.song.pageNumberingEnabled);
    XCTAssertEqual(self.song.pageNumberingFrom, 1);
    XCTAssertTrue(self.song.titlePageInfo);
    XCTAssertFalse(self.song.lastSystemExtended);
    XCTAssertTrue(self.song.spacingIncreasedWithLongerNotes);
    XCTAssertEqual(self.song.staffSize, 16);
    XCTAssertEqual(self.song.staffLabelsPrintStyle, MNLStaffLabelPrintStyleNone);
    XCTAssertEqual(self.song.measureNumberingStyle, MNLMeasureNumberingStyleNone);
    XCTAssertEqual(self.song.measureNumberingStart, 1);

    // "Page Setup" > "Margins"
    XCTAssertEqualWithAccuracy(self.song.pageMarginTop,     0.5, 0.0000001);
    XCTAssertEqualWithAccuracy(self.song.pageMarginInside,  0.5, 0.0000001);
    XCTAssertEqualWithAccuracy(self.song.pageMarginOutside, 0.5, 0.0000001);
    XCTAssertEqualWithAccuracy(self.song.pageMarginBottom,  0.5, 0.0000001);
    XCTAssertFalse(self.song.mirrorMargins);

    // "Page Setup" > "Fonts"
    // Will only test first font, as fonts are tested in detail elsewhere
    XCTAssert([self.song.fonts count] == 12);
    MNLFontInfo *font = self.song.fonts[0];
    XCTAssertEqualObjects(font.name, @"Times New Roman");
    XCTAssertEqual(font.size, (UInt16)10);
    XCTAssertEqual(font.style, MNLFontInfoStyleBoldItalics);
    XCTAssertEqual(font.scriptType, MNLFontInfoScriptTypeWindows1252_Western);

    // "Page Setup" > "Preview"
    // Nothing to test here (no file-specific info here)


    // Staves
    XCTAssertTrue([self.song.staves count] == 1);
    MNLStaff *staff = [self.song.staves firstObject];

    // "Staff properties" > "General"
    XCTAssertEqualObjects(staff.name, @"Staff");
    XCTAssertEqualObjects(staff.groupName, @"Standard");
    XCTAssertEqual(staff.endingBarStyle, MNLEndingBarStyleSectionClose);

    // "Staff properties" > "Visual"
    XCTAssertEqual(staff.upperHeight, 12);
    XCTAssertEqual(staff.lowerHeight, 12);
    XCTAssertEqual(staff.numStaffLines, 5);
    XCTAssertEqual(staff.color, MNLColorDefault);
    XCTAssertEqual(staff.style, MNLStaffStyleStandard);
    XCTAssertFalse(staff.layeredWithNextStaff);

    // "Staff properties" > "MIDI"
    XCTAssertEqual(staff.partVolume, 127);
    XCTAssertEqual(staff.stereoPan, 64);
    XCTAssertEqual(staff.transposition, 0);
    XCTAssertFalse(staff.muted);
    XCTAssertEqual(staff.playbackDeviceIndex, 0);
    XCTAssertEqual(staff.channelNumber, 0);

    // "Staff properties" > "Instrument"
    //TODO: patchName, patchListType
    XCTAssertFalse(staff.patchBankSelected);
    XCTAssertEqual(staff.bank, 0);
    XCTAssertEqual(staff.instrumentPatchIndex, 0);

    // "Lyrics" > "Configuration"
    XCTAssertNil(staff.lyrics);

    // StaffItems (none)
    XCTAssertTrue([staff.items count] == 0);

    // Non-Noteworthy properties
    // staff.visible (caused by: self.song.visibleStavesByIndex)
    XCTAssertTrue(staff.visible);
}

- (void)testFonts
{
    [self open:@"testFonts.nwc"];

    // "Page Setup" > "Fonts"
    XCTAssert([self.song.fonts count] == 12);
    MNLFontInfo *font = self.song.fonts[0];

    // "Staff Italic"
    font = self.song.fonts[0];
    XCTAssertEqualObjects(font.name, @"Times New Roman");
    XCTAssertEqual(font.size, (UInt16)10);
    XCTAssertEqual(font.style, MNLFontInfoStyleBoldItalics);
    XCTAssertEqual(font.scriptType, MNLFontInfoScriptTypeWindows1252_Western);

    // "Staff Bold"
    font = self.song.fonts[1];
    XCTAssertEqualObjects(font.name, @"Arial Narrow");
    XCTAssertEqual(font.size, (UInt16)0); // Lowest possible value
    XCTAssertEqual(font.style, MNLFontInfoStyleBold);
    XCTAssertEqual(font.scriptType, MNLFontInfoScriptTypeWindows1255_Hebrew);

    // "Staff Lyric"
    font = self.song.fonts[2];
    XCTAssertEqualObjects(font.name, @"Arial Black");
    XCTAssertEqual(font.size, (UInt16)255); // Byte.MAX
    XCTAssertEqual(font.style, MNLFontInfoStyleBoldItalics);
    XCTAssertEqual(font.scriptType, MNLFontInfoScriptTypeWindows1256_Arabic);

    // "Page Title Text"
    font = self.song.fonts[3];
    XCTAssertEqualObjects(font.name, @"Arial");
    XCTAssertEqual(font.size, (UInt16)256); // Byte.MAX + 1
    XCTAssertEqual(font.style, MNLFontInfoStylePlain);
    XCTAssertEqual(font.scriptType, MNLFontInfoScriptTypeWindows1253_Greek);

    // "Page Text"
    font = self.song.fonts[4];
    XCTAssertEqualObjects(font.name, @"Times New Roman");
    XCTAssertEqual(font.size, (UInt16)UINT16_MAX); // 65535, Short.MAX, Highest possible value
    XCTAssertEqual(font.style, MNLFontInfoStyleItalics);
    XCTAssertEqual(font.scriptType, MNLFontInfoScriptTypeWindows1254_Turkish);

    // "Page Small Text
    font = self.song.fonts[5];
    XCTAssertEqual(font.size, (UInt16)0);
    XCTAssertEqual(font.scriptType, MNLFontInfoScriptTypeWindows1257_Baltic);

    // "User 1"
    font = self.song.fonts[6];
    XCTAssertEqual(font.size, (UInt16)55538);
    XCTAssertEqual(font.scriptType, MNLFontInfoScriptTypeWindows1250_CentralEuropean);

    // "User 2"
    font = self.song.fonts[7];
    XCTAssertEqual(font.size, (UInt16)512);
    XCTAssertEqual(font.scriptType, MNLFontInfoScriptTypeWindows1251_Cyrillic);

    // "User 3"
    font = self.song.fonts[8];
    XCTAssertEqual(font.size, (UInt16)513);
    XCTAssertEqual(font.scriptType, MNLFontInfoScriptTypeWindows1258_Vietnamese);

    // "User 4"
    font = self.song.fonts[9];
    XCTAssertEqualObjects(font.name, @"Vladimir Script");

    // "User 5"
    font = self.song.fonts[10];

    // "User 6"
    font = self.song.fonts[11];
}

- (void)testStaffPropertiesVisual
{
    [self open:@"testStaffPropertiesVisual.nwc"];

    XCTAssert([self.song.staves count] == 6);
    MNLStaff *staff = self.song.staves[0];

    staff = self.song.staves[0];
    XCTAssertEqual(staff.upperHeight, 12);
    XCTAssertEqual(staff.lowerHeight, 12);
    XCTAssertEqual(staff.numStaffLines, 5);
    XCTAssertEqual(staff.color, MNLColorDefault);
    XCTAssertEqual(staff.style, MNLStaffStyleStandard);
    XCTAssertFalse(staff.layeredWithNextStaff);

    staff = self.song.staves[1];
    XCTAssertEqual(staff.upperHeight, 10);
    XCTAssertEqual(staff.lowerHeight, 10);
    XCTAssertEqual(staff.numStaffLines, 5);
    XCTAssertEqual(staff.color, MNLColorDefault);
    XCTAssertEqual(staff.style, MNLStaffStyleStandard);
    XCTAssertFalse(staff.layeredWithNextStaff);

    staff = self.song.staves[2];
    XCTAssertEqual(staff.upperHeight, 100); // Max enterable value
    XCTAssertEqual(staff.lowerHeight, 100); // Max enterable value
    XCTAssertEqual(staff.numStaffLines, 32); // Max enterable value
    XCTAssertEqual(staff.color, MNLColorHighlight3);
    XCTAssertEqual(staff.style, MNLStaffStyleOrchestral);
    XCTAssertTrue(staff.layeredWithNextStaff);

    staff = self.song.staves[3];
    XCTAssertEqual(staff.upperHeight, 1); // Min enterable value
    XCTAssertEqual(staff.lowerHeight, 1); // Min enterable value
    XCTAssertEqual(staff.numStaffLines, 0); // Min enterable value
    XCTAssertEqual(staff.color, MNLColorHighlight1);
    XCTAssertEqual(staff.style, MNLStaffStyleOrchestral);
    XCTAssertFalse(staff.layeredWithNextStaff);

    staff = self.song.staves[4];
    XCTAssertEqual(staff.upperHeight, 10);
    XCTAssertEqual(staff.lowerHeight, 10);
    XCTAssertEqual(staff.numStaffLines, 5);
    XCTAssertEqual(staff.color, MNLColorDefault);
    XCTAssertEqual(staff.style, MNLStaffStyleUpperGrandStaff);
    XCTAssertTrue(staff.layeredWithNextStaff);

    staff = self.song.staves[5];
    XCTAssertEqual(staff.upperHeight, 10);
    XCTAssertEqual(staff.lowerHeight, 10);
    XCTAssertEqual(staff.numStaffLines, 5);
    XCTAssertEqual(staff.color, MNLColorHighlight2);
    XCTAssertEqual(staff.style, MNLStaffStyleLowerGrandStaff);
    XCTAssertFalse(staff.layeredWithNextStaff);
}

- (void)testStaffPropertiesMidi
{
    [self open:@"testStaffPropertiesMidi.nwc"];

    XCTAssert([self.song.staves count] == 3);
    MNLStaff *staff = self.song.staves[0];

    staff = self.song.staves[0];
    XCTAssertEqual(staff.partVolume, 127); // Default
    XCTAssertEqual(staff.stereoPan, 64);
    XCTAssertEqual(staff.transposition, 0); // <0000>
    XCTAssertFalse(staff.muted);
    XCTAssertEqual(staff.playbackDeviceIndex, 0);
    XCTAssertEqual(staff.channelNumber, 0); // Visualized in NWC as +1

    staff = self.song.staves[1];
    XCTAssertEqual(staff.partVolume, -1); // Lowest
    XCTAssertEqual(staff.stereoPan, -1);
    XCTAssertEqual(staff.transposition, -24); // <e8ff>
    XCTAssertTrue(staff.muted);
    XCTAssertEqual(staff.playbackDeviceIndex, 0);
    XCTAssertEqual(staff.channelNumber, 0);

    staff = self.song.staves[2];
    XCTAssertEqual(staff.partVolume, 127); // Highest
    XCTAssertEqual(staff.stereoPan, 127);
    XCTAssertEqual(staff.transposition, 24); // <1800>
    XCTAssertFalse(staff.muted);
    XCTAssertEqual(staff.playbackDeviceIndex, 15);
    XCTAssertEqual(staff.channelNumber, 15);
}

- (void)testLyrics
{
    [self open:@"testLyrics.nwc"];

    XCTAssert([self.song.staves count] == 12);
    MNLStaff *staff = self.song.staves[0];

    // None
    //Lyrics info: <00000000 0000>
    staff = self.song.staves[0];
    XCTAssertNil(staff.lyrics);

    // Staff-1
    // 1 Lyric line, empty
    //Lyrics info: <01000100 0200>
    //Extra: <000000>
    //Extra: <000000>
    staff = self.song.staves[1];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 1);
    XCTAssertEqual(staff.lyrics.alignSyllable, MNLSyllableAlignmentStandard);
    XCTAssertEqual(staff.lyrics.alignStaff, MNLStaffAlignmentBottom);
    XCTAssertEqual(staff.lyrics.verticalOffset, 0);
    XCTAssertEqual(staff.upperHeight, 10);
    XCTAssertEqual(staff.lowerHeight, 14);
    MNLLyricsLine *line = staff.lyrics.lines[0];
    XCTAssertTrue([line.syllables count] == 0);

    // Staff-2
    // 1 Lyric line, empty
    //Lyrics info: <01000100 0100>
    //Extra: <640000>
    //Extra: <000000>
    staff = self.song.staves[2];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 1);
    XCTAssertEqual(staff.lyrics.alignSyllable, MNLSyllableAlignmentNoteStart);
    XCTAssertEqual(staff.lyrics.alignStaff, MNLStaffAlignmentTop);
    XCTAssertEqual(staff.lyrics.verticalOffset, 100);
    XCTAssertEqual(staff.upperHeight, 100);
    XCTAssertEqual(staff.lowerHeight, 100);
    line = staff.lyrics.lines[0];
    XCTAssertTrue([line.syllables count] == 0);

    // Staff-3
    // 1 Lyric line, empty
    //Lyrics info: <01000100 0300>
    //Extra: <9cff00>
    //Extra: <000000>
    staff = self.song.staves[3];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 1);
    XCTAssertEqual(staff.lyrics.alignSyllable, MNLSyllableAlignmentStandard);
    XCTAssertEqual(staff.lyrics.alignStaff, MNLStaffAlignmentTop);
    XCTAssertEqual(staff.lyrics.verticalOffset, -100);
    XCTAssertEqual(staff.upperHeight, 5);
    XCTAssertEqual(staff.lowerHeight, 5);
    line = staff.lyrics.lines[0];
    XCTAssertTrue([line.syllables count] == 0);

    // 1 Lyric line: "Test"
    staff = self.song.staves[4];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 1);
    line = staff.lyrics.lines[0];
    XCTAssertTrue([line.syllables count] == 1);
    XCTAssertEqualObjects(line.syllables[0], @"Test");

    // 1 Lyric line: "Te-e-est"
    staff = self.song.staves[5];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 1);
    line = staff.lyrics.lines[0];
    XCTAssertTrue([line.syllables count] == 3);
    XCTAssertEqualObjects(line.syllables[0], @"Te");
    XCTAssertEqualObjects(line.syllables[1], @"-e");
    XCTAssertEqualObjects(line.syllables[2], @"-est");

    // 2 Lyric line: "Te-e-est" | ""
    staff = self.song.staves[6];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 2);
    line = staff.lyrics.lines[0];
    XCTAssertTrue([line.syllables count] == 3);
    XCTAssertEqualObjects(line.syllables[0], @"Te");
    XCTAssertEqualObjects(line.syllables[1], @"-e");
    XCTAssertEqualObjects(line.syllables[2], @"-est");
    line = staff.lyrics.lines[1];
    XCTAssertTrue([line.syllables count] == 0);

    //Staff-7
    // 2 Lyric line: "Te-e-est" | "Aga-a-a-a-i-i-n"
    staff = self.song.staves[7];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 2);
    line = staff.lyrics.lines[0];
    XCTAssertTrue([line.syllables count] == 3);
    XCTAssertEqualObjects(line.syllables[0], @"Te");
    XCTAssertEqualObjects(line.syllables[1], @"-e");
    XCTAssertEqualObjects(line.syllables[2], @"-est");
    line = staff.lyrics.lines[1];
    XCTAssertTrue([line.syllables count] == 7);
    XCTAssertEqualObjects(line.syllables[0], @"Aga");
    XCTAssertEqualObjects(line.syllables[1], @"-a");
    XCTAssertEqualObjects(line.syllables[2], @"-a");
    XCTAssertEqualObjects(line.syllables[3], @"-a");
    XCTAssertEqualObjects(line.syllables[4], @"-i");
    XCTAssertEqualObjects(line.syllables[5], @"-i");
    XCTAssertEqualObjects(line.syllables[6], @"-n");

    //Staff-8
    // 1 Lyric line: "" exactly 1 block full of chars
    // 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrs

    staff = self.song.staves[8];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 1);
    line = staff.lyrics.lines[0];
    XCTAssertEqual([line.syllables count], (NSUInteger)27);
    XCTAssertEqualObjects(line.syllables[0], @"0123456789abcdefghijklmnopqrstuvwxyz");
    for (int i=1; i<26; i++)
        XCTAssertEqualObjects(line.syllables[i], @" 0123456789abcdefghijklmnopqrstuvwxyz");
    XCTAssertEqualObjects(line.syllables[26], @" 0123456789abcdefghijklmnopqrs");

    //Staff-9
    // 1 Lyric line: "" 2 blocks (1 full block + 1 letter)
    // 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrst

    staff = self.song.staves[9];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 1);
    line = staff.lyrics.lines[0];
    XCTAssertEqual([line.syllables count], (NSUInteger)27);
    XCTAssertEqualObjects(line.syllables[0], @"0123456789abcdefghijklmnopqrstuvwxyz");
    for (int i=1; i<26; i++)
        XCTAssertEqualObjects(line.syllables[i], @" 0123456789abcdefghijklmnopqrstuvwxyz");
    XCTAssertEqualObjects(line.syllables[26], @" 0123456789abcdefghijklmnopqrst");

    //Staff-10
    // 1 Lyric line: "" exactly 2 blocks full of chars
    /*
    0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmno
    pqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmno
     */

    staff = self.song.staves[10];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 1);
    line = staff.lyrics.lines[0];
    XCTAssertEqual([line.syllables count], (NSUInteger)55);
    XCTAssertEqualObjects(line.syllables[0], @"0123456789abcdefghijklmnopqrstuvwxyz");
    for (int i=1; i<27; i++)
        XCTAssertEqualObjects(line.syllables[i], @" 0123456789abcdefghijklmnopqrstuvwxyz");
    XCTAssertEqualObjects(line.syllables[27], @" 0123456789abcdefghijklmno");
    XCTAssertEqualObjects(line.syllables[28], @"\rpqrstuvwxyz");
    for (int i=29; i<54; i++)
        XCTAssertEqualObjects(line.syllables[i], @" 0123456789abcdefghijklmnopqrstuvwxyz");
    XCTAssertEqualObjects(line.syllables[54], @" 0123456789abcdefghijklmno");

    //Staff-11
    // 1 Lyric line: "" 3 blocks (2 full blocks + 1 letter)
    /*
    0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmno
    pqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnopqrstuvwxyz 0123456789abcdefghijklmnop
*/

    staff = self.song.staves[11];
    XCTAssertNotNil(staff.lyrics);
    XCTAssertTrue([staff.lyrics.lines count] == 1);
    line = staff.lyrics.lines[0];
    XCTAssertEqual([line.syllables count], (NSUInteger)55);
    XCTAssertEqualObjects(line.syllables[0], @"0123456789abcdefghijklmnopqrstuvwxyz");
    for (int i=1; i<27; i++)
        XCTAssertEqualObjects(line.syllables[i], @" 0123456789abcdefghijklmnopqrstuvwxyz");
    XCTAssertEqualObjects(line.syllables[27], @" 0123456789abcdefghijklmno");
    XCTAssertEqualObjects(line.syllables[28], @"\rpqrstuvwxyz");
    for (int i=29; i<54; i++)
        XCTAssertEqualObjects(line.syllables[i], @" 0123456789abcdefghijklmnopqrstuvwxyz");
    XCTAssertEqualObjects(line.syllables[54], @" 0123456789abcdefghijklmnop");
}

- (void)testNotes
{
    [self open:@"testNotes.nwc"];

    XCTAssert([self.song.staves count] == 1);
    MNLStaff *staff = self.song.staves[0];

    //XCTAssertTrue([staff.items count] == 1);
    MNLNote *note = [staff.items firstObject];
    XCTAssert([note isMemberOfClass:[MNLNote class]]);

    XCTAssertEqual(note.noteValue, 0);
    XCTAssertEqual(note.toneModifier, MNLAccidentalsNormal);
    XCTAssertEqual(note.duration, MNLTemporalDurationQuarter);
    XCTAssertEqual(note.durationModifier, MNLTemporalDurationModifierNormal);
    XCTAssertEqual(note.tupletGrouping, MNLTupletInfoNone);
    XCTAssertEqual(note.stemDirection, MNLStemDirectionAuto);
    XCTAssertEqual(note.beamInfo, MNLBeamInfoNone);
    XCTAssertEqual(note.slurInfo, MNLSlurInfoNone);
    XCTAssertFalse(note.staccato);
    XCTAssertFalse(note.accent);
    XCTAssertFalse(note.tenuto);
    XCTAssertFalse(note.graceNote);

    // "Notation properties" > "Notes"
    XCTAssertEqual(note.extraAccidentalSpacing, 0);
    XCTAssertEqual(note.extraNoteSpacing, 0);
    XCTAssertFalse(note.muted);
    XCTAssertFalse(note.withoutLegerLines);
    XCTAssertEqual(note.slurDirection, MNLSlurDirectionDefault);
    XCTAssertFalse(note.slurDirectionEnabled);
    XCTAssertEqual(note.tieDirection, MNLTieDirectionDefault);
    XCTAssertFalse(note.tieDirectionEnabled);
    XCTAssertEqual(note.lyricsSyllable, MNLLyricsSyllableDefault);

    // "Notation properties" > "Visibility"
    XCTAssertEqual(note.visibility, MNLStaffItemVisibilityDefault);
    XCTAssertEqual(note.color, MNLColorDefault);
}


@end
