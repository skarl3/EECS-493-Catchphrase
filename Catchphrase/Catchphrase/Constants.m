//
//  Constants.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "Constants.h"

// Segue identifiers
NSString *SegueToStartGameIdentifier = @"SegueToStartGame";
NSString *SegueToPlayGameIdentifier = @"SegueToPlayGame";

// Cell identifiers
NSString * const TeamCellIdentifier = @"TeamCell";
NSString * const NewTeamCellIdentifier = @"NewTeamCell";

// Team name constraints
NSInteger const kMinTeamNameLength = 1;
NSInteger const kMaxTeamNameLength = 15;

// Preference keys
static NSString *VibratePreferenceKey = @"Vibrate";
static NSString *ShowTimerPreferenceKey = @"ShowTimer";
static NSString *ScorePreferenceKey = @"Score";
static NSString *TimerPreferenceKey = @"Timer";
static NSString *EasyPreferenceKey = @"EasyWords";
static NSString *ModeratePreferenceKey = @"ModerateWords";
static NSString *HardPreferenceKey = @"HardWords";

static NSString *ReturningUserKey = @"ReturningUser";

@implementation Constants

static Constants* instance = nil;

+ (Constants*) instance
{
    @synchronized(self) {
        if(!instance) {
            instance = [Constants new];
            
            instance.FACEBOOK_BLUE = [UIColor colorWithRed:59/255.0 green:89/255.0 blue:152/255.0 alpha:1];
            instance.TWITTER_BLUE = [UIColor colorWithRed:64/255.0 green:153/255.0 blue:255/255.0 alpha:1];
            
            instance.LIGHT_BLUE = [UIColor colorWithRed:3/255.0 green:169/255.0 blue:244/255.0 alpha:1];
            instance.DARK_BLUE = [UIColor colorWithRed:1/255.0 green:87/255.0 blue:155/255.0 alpha:1];
            
            instance.LIGHT_GREEN = [UIColor colorWithRed:76/255.0 green:175/255.0 blue:80/255.0 alpha:1];
            instance.DARK_GREEN = [UIColor colorWithRed:27/255.0 green:94/255.0 blue:32/255.0 alpha:1];
            
            instance.LIGHT_ORANGE = [UIColor colorWithRed:255/255.0 green:142/255.0 blue:0/255.0 alpha:1];
            instance.DARK_ORANGE = [UIColor colorWithRed:230/255.0 green:81/255.0 blue:0/255.0 alpha:1];
            
            instance.EXTRA_LIGHT_BG = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
            instance.EXTRA_LIGHT_YELLOW_BG = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:200/255.0 alpha:1.0];
            instance.EXTRA_LIGHT_ORANGE_BG = [UIColor colorWithRed:255/255.0 green:200/255.0 blue:128/255.0 alpha:1.0];
            
            instance.LIGHT_BG = [UIColor colorWithRed:3/255.0 green:169/255.0 blue:244/255.0 alpha:0.6];
            //instance.LIGHT_BG = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            instance.DARK_BG = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
            
            instance.EXTRA_LIGHT_TEXT = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:0.8];
            instance.LIGHT_TEXT = [UIColor colorWithRed:97/255.0 green:97/255.0 blue:97/255.0 alpha:1];
            instance.DARK_TEXT = [UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1];
            
            instance.LIGHT_LINE = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
            instance.DARK_LINE = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
            
            instance.SHADOW_COLOR = [UIColor blackColor];
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:ReturningUserKey]) {
                NSLog(@"First time user, setting default preferences");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ReturningUserKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // Default preferences
                [self setVibrate:YES];
                [self setShowTimer:YES];
                [self setTimerLength:@60];
                [self setScoreToWin:@5];
                [self setEasy:YES];
                [self setModerate:NO];
                [self setHard:NO];
            }
        }
    }
    
    return instance;
}

+ (NSString*) regFont { return @"HelveticaNeue"; }
+ (NSString*) boldFont { return @"HelveticaNeue-Bold"; }
+ (NSString*) lightFont { return @"HelveticaNeue-Light"; }

+ (CGFloat) spacing { return 8.0f; }
+ (CGFloat) controlBarHeight { return 36.0f; }
+ (CGFloat) thinLineWidth { return 0.5f; }
+ (CGFloat) thickLineWidth { return 2.0f; }
+ (CGFloat) borderRadius { return 4.0f; }

+ (CGFloat) shadowOpacity { return 0.0f; }
+ (CGFloat) shadowRadius { return 0.0f; }
+ (CGSize) shadowOffset { return CGSizeZero; }

+ (CGFloat) smallBodyTextSize { return 12.0f; }
+ (CGFloat) bodyTextSize { return 16.0f; }
+ (CGFloat) titleTextSize { return 24.0f; }
+ (CGFloat) timerTextSize { return 28.0f; }
+ (CGFloat) bigWordSize { return 60.0f; }
+ (CGFloat) subTitleTextSize { return 18.0f; }


// Icons

+ (UIImage*) moreHorizontal
{
    return [[UIImage imageNamed:@"more_horizontal"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage*) moreVertical
{
    return [[UIImage imageNamed:@"more_vertical"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage*) settings
{
    return [[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage*) add
{
    return [[UIImage imageNamed:@"add_circle_unfilled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage*) close
{
    return [[UIImage imageNamed:@"close_circle_filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}


// Paths

+ (NSString*) saveDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

// Preferences getters

+ (BOOL) isVibrateOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:VibratePreferenceKey];
}

+ (BOOL) isShowTimerOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ShowTimerPreferenceKey];
}

+ (NSNumber*) scoreToWin
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:ScorePreferenceKey];
}

+ (NSNumber*) timerLength
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:TimerPreferenceKey];
}

+ (BOOL) isEasyOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:EasyPreferenceKey];
}

+ (BOOL) isModerateOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ModeratePreferenceKey];
}

+ (BOOL) isHardOn
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:HardPreferenceKey];
}

// Preferences setters

+ (void) setVibrate:(BOOL)vibrate
{
    [[NSUserDefaults standardUserDefaults] setBool:vibrate forKey:VibratePreferenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setShowTimer:(BOOL)show
{
    [[NSUserDefaults standardUserDefaults] setBool:show forKey:ShowTimerPreferenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setScoreToWin:(NSNumber*)score
{
    [[NSUserDefaults standardUserDefaults] setValue:score forKey:ScorePreferenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setTimerLength:(NSNumber*)timer
{
    [[NSUserDefaults standardUserDefaults] setValue:timer forKey:TimerPreferenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setEasy:(BOOL)easy
{
    [[NSUserDefaults standardUserDefaults] setBool:easy forKey:EasyPreferenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setModerate:(BOOL)moderate
{
    [[NSUserDefaults standardUserDefaults] setBool:moderate forKey:ModeratePreferenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) setHard:(BOOL)hard
{
    [[NSUserDefaults standardUserDefaults] setBool:hard forKey:HardPreferenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
