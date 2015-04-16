//
//  SettingsTableViewController.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "Constants.h"
#import "Model.h"

@interface SettingsTableViewController ()

// Labels
@property (strong, nonatomic) IBOutlet UILabel *timerLengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreToWinLabel;
@property (strong, nonatomic) IBOutlet UILabel *vibrateLabel;
@property (strong, nonatomic) IBOutlet UILabel *easyLabel;
@property (strong, nonatomic) IBOutlet UILabel *mediumLabel;
@property (strong, nonatomic) IBOutlet UILabel *hardLabel;
@property (strong, nonatomic) IBOutlet UILabel *deleteAllLabel;
@property (strong, nonatomic) IBOutlet UILabel *showTimerLabel;
@property (strong, nonatomic) IBOutlet UILabel *howToPlayLabel;

// Control labels
@property (strong, nonatomic) IBOutlet UILabel *timerControlLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreControlLabel;

// Controls
@property (strong, nonatomic) IBOutlet UISlider *timeSlider;
@property (strong, nonatomic) IBOutlet UISwitch *showTimerSwitch;

@property (strong, nonatomic) IBOutlet UIStepper *scoreStepper;
@property (strong, nonatomic) IBOutlet UISwitch *vibrateSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *easySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *mediumSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *hardSwitch;

@property (strong, nonatomic) CAGradientLayer *backgroundGradient;

@end

@implementation SettingsTableViewController

const static CGFloat kHeaderHeight = 60.0;
const static NSInteger kRoundingDistance = 2;

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
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundView = [UIView new];
    [self.tableView.backgroundView.layer insertSublayer:_backgroundGradient atIndex:0];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.separatorColor = [UIColor clearColor];
    //self.tableView.separatorEffect = [UIVibrancyEffect effectForBlurEffect:UIBlurEffectStyleExtraLight];
    
    self.timerLengthLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.showTimerLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.scoreToWinLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.vibrateLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.easyLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.mediumLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.hardLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.howToPlayLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.deleteAllLabel.font = [UIFont fontWithName:[Constants boldFont] size:[Constants bodyTextSize]];
    
    self.timerLengthLabel.textColor = [[Constants instance] DARK_TEXT];
    self.showTimerLabel.textColor = [[Constants instance] DARK_TEXT];
    self.scoreToWinLabel.textColor = [[Constants instance] DARK_TEXT];
    self.vibrateLabel.textColor = [[Constants instance] DARK_TEXT];
    self.easyLabel.textColor = [[Constants instance] DARK_TEXT];
    self.mediumLabel.textColor = [[Constants instance] DARK_TEXT];
    self.hardLabel.textColor = [[Constants instance] DARK_TEXT];
    self.deleteAllLabel.textColor = [UIColor redColor];
    
    self.timerControlLabel.font = [UIFont fontWithName:[Constants boldFont] size:[Constants smallBodyTextSize]];
    self.scoreControlLabel.font = [UIFont fontWithName:[Constants boldFont] size:[Constants smallBodyTextSize]];
    
    self.timerControlLabel.textColor = [[Constants instance] LIGHT_TEXT];
    self.scoreControlLabel.textColor = [[Constants instance] LIGHT_TEXT];
    
    // Control setup
    self.timeSlider.tintColor = [[Constants instance] LIGHT_BLUE];
    self.timeSlider.minimumValue = 10.0f;
    self.timeSlider.maximumValue = 120.0f;
    [self.timeSlider addTarget:self
                        action:@selector(timerChangeEnded:)
              forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    self.scoreStepper.tintColor = [[Constants instance] LIGHT_BLUE];
    [self.scoreStepper setMinimumValue:1.0];
    [self.scoreStepper setMaximumValue:50.0];
    
    // Load preferences
    self.timeSlider.value = [Constants timerLength].floatValue;
    self.timerControlLabel.text = [NSString stringWithFormat:@"%d sec", (int)self.timeSlider.value];
    self.scoreStepper.value = [Constants scoreToWin].floatValue;
    self.scoreControlLabel.text = [NSString stringWithFormat:@"%d", (int)self.scoreStepper.value ];//[NSString stringWithFormat:@"%d round%@", (int)self.scoreStepper.value,
                                        //(self.scoreStepper.value==1) ? @"" : @"s"];
    self.vibrateSwitch.on = [Constants isVibrateOn];
    self.vibrateSwitch.tintColor = [[Constants instance] LIGHT_BG];
    self.vibrateSwitch.onTintColor = [[Constants instance] LIGHT_BLUE];
    self.showTimerSwitch.on = [Constants isShowTimerOn];
    self.showTimerSwitch.tintColor = [[Constants instance] LIGHT_BG];
    self.showTimerSwitch.onTintColor = [[Constants instance] LIGHT_BLUE];
    self.easySwitch.on = [Constants isEasyOn];
    self.easySwitch.tintColor = [[Constants instance] LIGHT_BG];
    self.easySwitch.onTintColor = [[Constants instance] LIGHT_BLUE];
    self.mediumSwitch.on = [Constants isModerateOn];
    self.mediumSwitch.tintColor = [[Constants instance] LIGHT_BG];
    self.mediumSwitch.onTintColor = [[Constants instance] LIGHT_BLUE];
    self.hardSwitch.on = [Constants isHardOn];
    self.hardSwitch.tintColor = [[Constants instance] LIGHT_BG];
    self.hardSwitch.onTintColor = [[Constants instance] LIGHT_BLUE];
}

- (IBAction)timerSliderChanged:(id)sender
{
    self.timerControlLabel.text = [NSString stringWithFormat:@"%d sec", (int)self.timeSlider.value];
    [Constants setTimerLength:@(self.timeSlider.value)];
}

- (void) timerChangeEnded:(id)sender
{
    // Round the final value of the slider if it's close to a multiple of ten
    NSInteger val = (int)self.timeSlider.value;
    if(val % 10 <= kRoundingDistance) {
        val = val / 10 * 10;
    }
    
    else if(val % 10 >= 10 - kRoundingDistance) {
        val = val / 10 * 10 + 10;
    }
    
    [self.timeSlider setValue:val animated:YES];
    self.timerControlLabel.text = [NSString stringWithFormat:@"%ld sec", (long)val];
    [Constants setTimerLength:@(val)];
}

- (IBAction)scoreStepperChanged:(id)sender
{
    self.scoreControlLabel.text = [NSString stringWithFormat:@"%d", (int)self.scoreStepper.value ];//[NSString stringWithFormat:@"%d round%@", (int)self.scoreStepper.value,
                                   //(self.scoreStepper.value==1) ? @"" : @"s"];
    [Constants setScoreToWin:@(self.scoreStepper.value)];
}

- (IBAction)switchFlipped:(id)sender
{
    if(sender==_vibrateSwitch) {
        [Constants setVibrate:_vibrateSwitch.isOn];
    }
    
    else if(sender==_showTimerSwitch) {
        [Constants setShowTimer:_showTimerSwitch.isOn];
    }
    
    else if(sender==_easySwitch) {
        [Constants setEasy:_easySwitch.isOn];
    }
    
    else if(sender==_mediumSwitch) {
        [Constants setModerate:_mediumSwitch.isOn];
    }
    
    else if(sender==_hardSwitch) {
        [Constants setHard:_hardSwitch.isOn];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 320, 20);
    titleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    titleLabel.font = [UIFont fontWithName:[Constants boldFont]
                                      size:[Constants bodyTextSize]];
    titleLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    CGRect frame = titleLabel.frame;
    frame.size.height = [titleLabel sizeThatFits:CGSizeMake(320, 0)].height;
    titleLabel.frame = frame;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kHeaderHeight)];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:titleLabel];
    
    [headerView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-space-[label]-space-|"
                                                                        options:0
                                                                        metrics:@{ @"space":@([Constants spacing]*2) }
                                                                          views:@{ @"label":titleLabel }]];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:headerView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:titleLabel
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:[Constants spacing]];
    [headerView addConstraint:bottom];
    
    return headerView;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(![self tableView:tableView titleForHeaderInSection:section] ||
       [[self tableView:tableView titleForHeaderInSection:section] isEqualToString:@""]) {
        return kHeaderHeight/4;
    }
    
    return kHeaderHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Check if the user tapped the last row in the last section (delete all button)
    NSInteger numSections = [tableView numberOfSections];
    NSInteger numRows = [tableView numberOfRowsInSection:numSections-1];
    
    if (indexPath.section == numSections-2 && indexPath.row==0) {
        //how to play
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://en.wikipedia.org/wiki/Catch_Phrase_%28game%29"]];
    }
    else if(indexPath.section==numSections-1 && indexPath.row==numRows-1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete Everything"
                                                                                 message:@"Are you sure you want to delete all saved data? You can't undo this action."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 //
                                                             }];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete"
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction *action) {
                                                                 [[Model sharedManager] destroyAllObjects];
                                                             }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Transitions

- (void) viewWillTransitionToSize:(CGSize)size
        withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Handle orientation changes
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        _backgroundGradient.bounds = CGRectMake(0, 0, size.width, size.height);
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}

@end
