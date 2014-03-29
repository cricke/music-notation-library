//
//  MNLFontInfo.h
//  MusicNotationLibrary
//
//  Created by Christian O. Andersson on 2013-07-15.
//  Copyright (c) 2013 Cinus. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, MNLFontInfoStyle) {
    MNLFontInfoStylePlain,
    MNLFontInfoStyleBold,
    MNLFontInfoStyleItalics,
    MNLFontInfoStyleBoldItalics
};
typedef NS_ENUM(unsigned char, MNLFontInfoScriptType) {
    MNLFontInfoScriptTypeWindows1250_CentralEuropean,
    MNLFontInfoScriptTypeWindows1251_Cyrillic,
    MNLFontInfoScriptTypeWindows1252_Western,
    MNLFontInfoScriptTypeWindows1253_Greek,
    MNLFontInfoScriptTypeWindows1254_Turkish,
    MNLFontInfoScriptTypeWindows1255_Hebrew,
    MNLFontInfoScriptTypeWindows1256_Arabic,
    MNLFontInfoScriptTypeWindows1257_Baltic,
    MNLFontInfoScriptTypeWindows1258_Vietnamese
};


@interface MNLFontInfo : NSObject
@property (nonatomic,retain) NSString *name;
@property (nonatomic,assign) MNLFontInfoStyle style;
@property (nonatomic,assign) UInt16 size;
@property (nonatomic,assign) MNLFontInfoScriptType scriptType;

@end
