//
//  PlayViewController.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "PlayViewController.h"
#import "Constants.h"
#import "UIView+Additions.h"
#import "Team.h"
#import "Game.h"
#import "Round.h"
#import "Word.h"
#import "Model.h"
//#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define FWIDTH self.view.frame.size.width
#define FHEIGHT self.view.frame.size.height

@interface PlayViewController ()

@property (assign, nonatomic) BOOL roundInProgress;

// Outlets
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UILabel *timeRemainingLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *wordSlider;
@property (strong, nonatomic) IBOutlet UIButton *startRoundButton;
@property (strong, nonatomic) IBOutlet UILabel *teamOneScore;
@property (strong, nonatomic) IBOutlet UILabel *teamTwoScore;
@property (strong, nonatomic) IBOutlet UILabel *centralLabel;

// Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *startRoundTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeRemainingHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scoresWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centerLabelCenterXConstraint;

// Round/timer
@property (strong, nonatomic) Round *currentRound;
@property (strong, nonatomic) NSTimer *countdownTimer;
@property (nonatomic) NSInteger remainingTicks;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centralLabelHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *centralLabelWidthConstraint;

// Swipe
@property (nonatomic) BOOL didSwipeLeft;

// Players
@property (strong, nonatomic) Team *playerOne;
@property (strong, nonatomic) Team *playerTwo;

// Audio
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (strong, nonatomic) CAGradientLayer *backgroundGradient;

@end

@implementation PlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UI setup
    _backgroundGradient = [CAGradientLayer layer];
    _backgroundGradient.bounds = self.view.bounds;
    _backgroundGradient.anchorPoint = CGPointZero;
    _backgroundGradient.colors = @[ (id)[[[Constants instance] LIGHT_BG] CGColor],
                                    (id)[[[Constants instance] LIGHT_BLUE] CGColor]
                                    ];
    [self.view.layer insertSublayer:_backgroundGradient atIndex:0];
    
    _startRoundButton.titleLabel.font = [UIFont fontWithName:[Constants boldFont]
                                                        size:[Constants titleTextSize]];
    _startRoundButton.titleLabel.numberOfLines = 0;
    _startRoundButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _startRoundButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_startRoundButton setTitleColor:[UIColor whiteColor]
                            forState:UIControlStateNormal];
    
    _timeRemainingLabel.font = [UIFont fontWithName:[Constants lightFont]
                                               size:[Constants timerTextSize]];
    _timeRemainingLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    _timeRemainingLabel.hidden = ![Constants isShowTimerOn];
    
    _centralLabel.font = [UIFont fontWithName:[Constants boldFont]
                                        size:[Constants bigWordSize]];
    _centralLabel.textColor = [UIColor whiteColor];
    _centralLabel.alpha = 0;
    /*_centralLabel.numberOfLines = 0;
    _centralLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _centralLabel.minimumScaleFactor = .5;
    _centralLabelHeightConstraint.constant = 0;
    _centralLabelWidthConstraint.constant = 0;*/ //setup in storyboard
    
    [_closeButton setImage:[Constants close] forState:UIControlStateNormal];
    _closeButton.imageView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    [_menuButton setImage:[Constants moreVertical] forState:UIControlStateNormal];
    _menuButton.imageView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    
    _teamOneScore.numberOfLines = 0;
    _teamOneScore.lineBreakMode = NSLineBreakByWordWrapping;
    
    _teamTwoScore.numberOfLines = 0;
    _teamTwoScore.lineBreakMode = NSLineBreakByWordWrapping;
    
    // Add swipe recognizer for switching words
    UIPanGestureRecognizer *left = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(handlePan:)];
    [self.view addGestureRecognizer:left];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // Get the players
    if(_currentGame.winningPlayer) {
        _playerOne = _currentGame.winningPlayer;
        _playerTwo = _currentGame.losingPlayer;
    }
    
    else {
        NSArray *allPlayers = _currentGame.otherPlayers.allObjects;
        _playerOne = [allPlayers firstObject];
        _playerTwo = [allPlayers lastObject];
    }
    
    // Set initial state of game screen
    if(self.currentGame.game_finished) {
        [self resetToGameOverAnimated:NO];
    }
    
    else {
        [self resetToRoundPaused];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // If there's an unfinished round, kill it
    if(_roundInProgress) {
        [_countdownTimer invalidate];
        _countdownTimer = nil;
        [[Model sharedManager] destroyObject:_currentRound];
    }
}

- (void) updateScoreLabels
{
    NSInteger playerOneCount = 0;
    NSInteger playerTwoCount = 0;
    
    for(Round *r in _currentGame.rounds) {
        if(r.winningPlayer==_playerOne) {
            playerOneCount++;
        }
        
        else if(r.winningPlayer==_playerTwo) {
            playerTwoCount++;
        }
    }
    
    UIFont *boldFont = [UIFont fontWithName:[Constants boldFont] size:[Constants titleTextSize]];
    UIFont *regularFont = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    UIColor *foregroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    UIColor *backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    
    NSDictionary *attrs = @{ NSFontAttributeName: boldFont, NSForegroundColorAttributeName: foregroundColor };
    NSDictionary *subAttrs = @{ NSFontAttributeName: regularFont, NSForegroundColorAttributeName: backgroundColor };
    
    NSString *teamOneString = [NSString stringWithFormat:@"%@\r%ld %@%@",
                               _playerOne.team_name, (long)playerOneCount, @"point", (playerOneCount!=1) ? @"s" : @""];
    NSString *teamTwoString = [NSString stringWithFormat:@"%@\r%ld %@%@",
                               _playerTwo.team_name, (long)playerTwoCount, @"point", (playerTwoCount!=1) ? @"s" : @""];
    
    NSRange teamOneRange = NSMakeRange(0, _playerOne.team_name.length);
    NSRange teamTwoRange = NSMakeRange(0, _playerTwo.team_name.length);
    
    NSMutableAttributedString *teamOneAttrString = [[NSMutableAttributedString alloc] initWithString:teamOneString
                                                                                          attributes:subAttrs];
    NSMutableAttributedString *teamTwoAttrString = [[NSMutableAttributedString alloc] initWithString:teamTwoString
                                                                                          attributes:subAttrs];
    
    [teamOneAttrString setAttributes:attrs range:teamOneRange];
    [teamTwoAttrString setAttributes:attrs range:teamTwoRange];
    
    [_teamOneScore setAttributedText:teamOneAttrString];
    [_teamTwoScore setAttributedText:teamTwoAttrString];
}

- (void) resetToGameOverAnimated:(BOOL)animated
{
    [self.view layoutIfNeeded];
    
    [self updateScoreLabels];
    
    _roundInProgress = NO;
    _menuButton.enabled = NO;
    _startRoundTopConstraint.constant = self.view.frame.size.height;
    _timeRemainingHeightConstraint.constant = 0;
    _scoresWidthConstraint.constant = FWIDTH;
    
    _centralLabel.text = (_currentGame.winningPlayer)
                            ? [NSString stringWithFormat:@"%@ won", self.currentGame.winningPlayer.team_name]
                            : @"Tie! Guess you'll have to rematch...";

    _centralLabel.textColor = [UIColor whiteColor];
    _centralLabel.alpha = 0;
    _centralLabelHeightConstraint.constant = [_centralLabel sizeThatFits:CGSizeMake(FWIDTH*3.0f/4.0f, 0)].height;
    _centralLabelWidthConstraint.constant = FWIDTH*3.0f/4.0f;
    
    void (^animations)() = ^void() {
        _startRoundButton.alpha = 0.0;
        _wordSlider.alpha = 0;
        _teamOneScore.alpha = 1.0;
        _teamTwoScore.alpha = 1.0;
        _centralLabel.alpha = 1.0;
    };
    
    if(animated) {
        [self.view animateLayoutIfNeededWithBounce:YES
                                           options:0
                                        animations:^{
                                            animations();
                                        }];
    }
    
    else {
        animations();
        [self.view layoutIfNeeded];
    }
}

- (void) resetToRoundPaused
{
    [self.view layoutIfNeeded];
    
    [self updateScoreLabels];
    
    _roundInProgress = NO;
    _menuButton.enabled = NO;
    _startRoundTopConstraint.constant = 0;
    _timeRemainingHeightConstraint.constant = 0;
    _scoresWidthConstraint.constant = FWIDTH;
    _centralLabelHeightConstraint.constant = 0;
    _centralLabelWidthConstraint.constant = 0;
    
    [self.view animateLayoutIfNeededWithBounce:YES
                                       options:0
                                    animations:^{
                                        _startRoundButton.enabled = YES;
                                        _startRoundButton.titleLabel.font = [UIFont fontWithName:[Constants boldFont]
                                                                                            size:[Constants titleTextSize]];
                                        [_startRoundButton setTitleColor:[UIColor whiteColor]
                                                                forState:UIControlStateNormal];
                                        [_startRoundButton setTitle:@"Tap to start the next round!"
                                                           forState:UIControlStateNormal];
                                        _wordSlider.alpha = 0;
                                        _teamOneScore.alpha = 1.0;
                                        _teamTwoScore.alpha = 1.0;
                                        _centralLabel.alpha = 0;
                                    }];
}

- (IBAction)startRoundTapped:(id)sender
{
    [self.view layoutIfNeeded];
    
    _startRoundTopConstraint.constant = self.view.frame.size.height
                                        - [_startRoundButton sizeThatFits:CGSizeMake(_startRoundButton.frame.size.width, 0)].height
                                        - ([Constants spacing] * 2);
    _timeRemainingHeightConstraint.constant = [Constants spacing] * 11;
    
    [self.view animateLayoutIfNeededWithBounce:YES
                                       options:0
                                    animations:^{
                                        _startRoundButton.enabled = NO;
                                        _startRoundButton.titleLabel.font = [UIFont fontWithName:[Constants lightFont]
                                                                                            size:[Constants subTitleTextSize]];
                                        [_startRoundButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.4]
                                                                forState:UIControlStateNormal];
                                        [_startRoundButton setTitle:@"Swipe for a new word"
                                                           forState:UIControlStateNormal];
                                        _wordSlider.alpha = 1.0;
                                        _teamOneScore.alpha = 0;
                                        _teamTwoScore.alpha = 0;
                                    }];
    
    [self beginRound];
}

- (void) beginRound
{
    _roundInProgress = YES;
    _menuButton.enabled = YES;
    _currentRound = [self.currentGame newRound];
    
    if (_countdownTimer) {
        return;
    }
    
    _remainingTicks = [Constants timerLength].integerValue;
    [self updateTimerLabel];
    
    _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(handleTimerTick)
                                                     userInfo:nil
                                                      repeats:YES];
    
    [self generateNewWord];
}

- (void) handlePan:(UIPanGestureRecognizer *)sender
{
    if(_roundInProgress && sender.state == UIGestureRecognizerStateBegan) {
        _didSwipeLeft = ([sender velocityInView:self.view].x <= 0);
        [self generateNewWord];
    }
}

- (void) generateNewWord
{
    [_centralLabel layoutIfNeeded];
    _centralLabel.textColor = [UIColor whiteColor];
    float directionMultiplier = _didSwipeLeft ? 1.0f : -1.0f;
    float animDuration = 0.3;
    
    _centerLabelCenterXConstraint.constant = [Constants spacing] * 2 * directionMultiplier;
    
    [_centralLabel animateLayoutIfNeededWithDuration:animDuration
                                              bounce:YES
                                             options:0
                                          animations:^{
                                              _centralLabel.alpha = 0;
                                          }
                                          completion:^{
                                              _centerLabelCenterXConstraint.constant = -[Constants spacing] * 2 * directionMultiplier;
                                              _centralLabel.text = [[Word wordManager] wordFromEasy:[Constants isEasyOn]
                                                                                          andMedium:[Constants isModerateOn]
                                                                                            andHard:[Constants isHardOn]];
                                              [_centralLabel layoutIfNeeded];
                                              _centerLabelCenterXConstraint.constant = 0;
                                              _centralLabelHeightConstraint.constant =
                                                    [_centralLabel sizeThatFits:CGSizeMake(FWIDTH*3.0f/4.0f, 0)].height;
                                              _centralLabelWidthConstraint.constant = FWIDTH*3.0f/4.0f;
                                              
                                              [_centralLabel animateLayoutIfNeededWithDuration:animDuration
                                                                                        bounce:YES
                                                                                       options:0
                                                                                    animations:^{
                                                                                        _centralLabel.alpha = 1.0;
                                                                                    }
                                                                                    completion:^{
                                                                                        
                                                                                    }];
                                          }];
}

- (void) endRound
{
    _roundInProgress = NO;
    _menuButton.enabled = NO;
    [_countdownTimer invalidate];
    _countdownTimer = nil;
    
    if ([Constants isVibrateOn]) { //play finished sound
        
        NSError* error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                               error:&error];
        if (!error) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"mp3"];
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
            
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                                      error:&error];
            if (!error) {
                self.audioPlayer.volume = 1.0;
                [self.audioPlayer prepareToPlay];
                [[AVAudioSession sharedInstance] setActive:YES error:&error];
                if (!error) {
                    [self.audioPlayer play];
                }
            }
        }
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Time's Up!"
                                                                             message:@"Which team won the round?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    for(Team *t in _currentGame.otherPlayers) {
        UIAlertAction *teamAction = [UIAlertAction actionWithTitle:t.team_name
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 [_currentRound finishRoundWithWinner:t];
                                                                 if(_currentGame.rounds.count >= [Constants scoreToWin].intValue) {
                                                                     [_currentGame finishGame];
                                                                     [self resetToGameOverAnimated:YES];
                                                                 }
                                                                 
                                                                 else {
                                                                     [self resetToRoundPaused];
                                                                 }
                                                             }];
        
        [alertController addAction:teamAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Scrap this round"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *action) {
                                                             [[Model sharedManager] destroyObject:_currentRound];
                                                             [self resetToRoundPaused];
                                                         }];
    
    [alertController addAction:cancelAction];
    
    if(self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    
    else {
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void) handleTimerTick
{
    _remainingTicks--;
    [self updateTimerLabel];
    
    if (_remainingTicks <= 0) {
        [self endRound];
    }
    
    else if(_remainingTicks <= 5) {
        if ([Constants isVibrateOn]) {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate); // Vibrate for last 5 ticks if enabled
        }
        
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1.25, 1.25);
        [UIView animateWithDuration:0.15
                         animations:^{
                             _timeRemainingLabel.transform = scaleTransform;
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  _timeRemainingLabel.transform = CGAffineTransformIdentity;
                                              }
                                              completion:nil];
                         }];
    }
}

- (void)updateTimerLabel
{
    NSDateComponentsFormatter *timeFormatter = [NSDateComponentsFormatter new];
    timeFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    timeFormatter.allowedUnits = (NSCalendarUnitMinute | NSCalendarUnitSecond);
    timeFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    _timeRemainingLabel.text = [timeFormatter stringFromTimeInterval:_remainingTicks];
}


- (IBAction)menuButtonTapped:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.currentGame.gameName
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *action) {
                                                             //
                                                         }];
    
    if(_roundInProgress) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Scrap this round"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction *action) {
                                                                 [_countdownTimer invalidate];
                                                                 _countdownTimer = nil;
                                                                 [[Model sharedManager] destroyObject:_currentRound];
                                                                 [self resetToRoundPaused];
                                                             }];
        
        [alertController addAction:cancelAction];
    }
    
    
    [alertController addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.menuButton;
        popover.sourceRect = self.menuButton.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

#pragma mark - Transitions

- (void) viewWillTransitionToSize:(CGSize)size
        withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    _startRoundTopConstraint.constant =
        (_roundInProgress) ? size.height
                             - [_startRoundButton sizeThatFits:CGSizeMake(_startRoundButton.frame.size.width, 0)].height
                             - ([Constants spacing] * 2)
                           : 0;
    _centralLabelHeightConstraint.constant = [_centralLabel sizeThatFits:CGSizeMake(size.width/2, 0)].height;
    _centralLabelWidthConstraint.constant = size.width/2;
    
    // Handle orientation changes
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self.view layoutIfNeeded];
        _backgroundGradient.bounds = CGRectMake(0, 0, size.width, size.height);
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}

@end
