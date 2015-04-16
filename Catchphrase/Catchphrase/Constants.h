//
//  Constants.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *SegueToStartGameIdentifier;
extern NSString *SegueToPlayGameIdentifier;

extern NSString * const TeamCellIdentifier;
extern NSString * const NewTeamCellIdentifier;

extern NSInteger const kMinTeamNameLength;
extern NSInteger const kMaxTeamNameLength;

@interface Constants : NSObject

+ (Constants*) instance;

/*
 /////////////////////
 // COLORS ///////////
 /////////////////////
 */

// Social
@property (nonatomic, strong) UIColor* FACEBOOK_BLUE;
@property (nonatomic, strong) UIColor* TWITTER_BLUE;

// Theme
@property (nonatomic, strong) UIColor* LIGHT_BLUE;
@property (nonatomic, strong) UIColor* DARK_BLUE;
@property (nonatomic, strong) UIColor* LIGHT_GREEN;
@property (nonatomic, strong) UIColor* DARK_GREEN;
@property (nonatomic, strong) UIColor* LIGHT_ORANGE;
@property (nonatomic, strong) UIColor* DARK_ORANGE;

// Backgrounds
@property (nonatomic, strong) UIColor* EXTRA_LIGHT_BG;
@property (nonatomic, strong) UIColor* EXTRA_LIGHT_YELLOW_BG;
@property (nonatomic, strong) UIColor* EXTRA_LIGHT_ORANGE_BG;
@property (nonatomic, strong) UIColor* LIGHT_BG;
@property (nonatomic, strong) UIColor* DARK_BG;

// Lines
@property (nonatomic, strong) UIColor* LIGHT_LINE;
@property (nonatomic, strong) UIColor* DARK_LINE;

// Text
@property (nonatomic, strong) UIColor* EXTRA_LIGHT_TEXT;
@property (nonatomic, strong) UIColor* LIGHT_TEXT;
@property (nonatomic, strong) UIColor* DARK_TEXT;

// Other
@property (nonatomic, strong) UIColor* SHADOW_COLOR;


/*
 /////////////////////
 // DIMENSIONS ///////
 /////////////////////
 */

+ (CGFloat) spacing;
+ (CGFloat) controlBarHeight;

+ (CGFloat) thinLineWidth;
+ (CGFloat) thickLineWidth;
+ (CGFloat) borderRadius;

+ (CGFloat) shadowOpacity;
+ (CGSize) shadowOffset;
+ (CGFloat) shadowRadius;


/*
 /////////////////////
 // TEXT /////////////
 /////////////////////
 */

// Fonts
+ (NSString*) regFont;
+ (NSString*) boldFont;
+ (NSString*) lightFont;

// Sizes
+ (CGFloat) smallBodyTextSize;
+ (CGFloat) bodyTextSize;
+ (CGFloat) titleTextSize;
+ (CGFloat) timerTextSize;
+ (CGFloat) bigWordSize;
+ (CGFloat) subTitleTextSize;


/*
 /////////////////////
 // IMAGES ///////////
 /////////////////////
 */

+ (UIImage*) moreHorizontal;
+ (UIImage*) moreVertical;
+ (UIImage*) settings;
+ (UIImage*) add;
+ (UIImage*) close;


/*
 /////////////////////
 // PATHS ////////////
 /////////////////////
 */

+ (NSString*) saveDirectory;


/*
 /////////////////////
 // PREFS ////////////
 /////////////////////
 */

// Getters
+ (BOOL) isVibrateOn;
+ (BOOL) isShowTimerOn;
+ (NSNumber*) scoreToWin;
+ (NSNumber*) timerLength;
+ (BOOL) isEasyOn;
+ (BOOL) isModerateOn;
+ (BOOL) isHardOn;

// Setters
+ (void) setVibrate:(BOOL)vibrate;
+ (void) setShowTimer:(BOOL)show;
+ (void) setScoreToWin:(NSNumber*)score;
+ (void) setTimerLength:(NSNumber*)timer;
+ (void) setEasy:(BOOL)easy;
+ (void) setModerate:(BOOL)moderate;
+ (void) setHard:(BOOL)hard;

@end