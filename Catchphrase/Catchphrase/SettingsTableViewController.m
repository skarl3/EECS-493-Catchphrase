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

// Control labels
@property (strong, nonatomic) IBOutlet UILabel *timerControlLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreControlLabel;

// Controls
@property (strong, nonatomic) IBOutlet UISlider *timeSlider;
@property (strong, nonatomic) IBOutlet UIStepper *scoreStepper;
@property (strong, nonatomic) IBOutlet UISwitch *vibrateSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *easySwitch;
@property (strong, nonatomic) IBOutlet UISwitch *mediumSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *hardSwitch;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UI setup
    self.tableView.backgroundColor = [[Constants instance] LIGHT_BG];
    
    self.timerLengthLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.scoreToWinLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.vibrateLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.easyLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.mediumLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.hardLabel.font = [UIFont fontWithName:[Constants lightFont] size:[Constants subTitleTextSize]];
    self.deleteAllLabel.font = [UIFont fontWithName:[Constants boldFont] size:[Constants bodyTextSize]];
    
    self.timerLengthLabel.textColor = [[Constants instance] DARK_TEXT];
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
    self.timeSlider.minimumValue = 10.0f;
    self.timeSlider.maximumValue = 120.0f;
    
    [self.scoreStepper setMinimumValue:1.0];
    [self.scoreStepper setMaximumValue:50.0];
    
    // Load preferences
    self.timeSlider.value = [Constants timerLength].floatValue;
    self.timerControlLabel.text = [NSString stringWithFormat:@"%d sec", (int)self.timeSlider.value];
    self.scoreStepper.value = [Constants scoreToWin].floatValue;
    self.scoreControlLabel.text = [NSString stringWithFormat:@"%d pts", (int)self.scoreStepper.value];
    self.vibrateSwitch.on = [Constants isVibrateOn];
    self.easySwitch.on = [Constants isEasyOn];
    self.mediumSwitch.on = [Constants isModerateOn];
    self.hardSwitch.on = [Constants isHardOn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)timerSliderChanged:(id)sender
{
    self.timerControlLabel.text = [NSString stringWithFormat:@"%d sec", (int)self.timeSlider.value];
    [Constants setTimerLength:@(self.timeSlider.value)];
}

- (IBAction)scoreStepperChanged:(id)sender
{
    self.scoreControlLabel.text = [NSString stringWithFormat:@"%d pt%@", (int)self.scoreStepper.value,
                                   (self.scoreStepper.value==1) ? @"" : @"s"];
    [Constants setScoreToWin:@(self.scoreStepper.value)];
}

- (IBAction)switchFlipped:(id)sender
{
    if(sender==_vibrateSwitch) {
        [Constants setVibrate:_vibrateSwitch.isOn];
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Check if the user tapped the last row in the last section (delete all button)
    NSInteger numSections = [tableView numberOfSections];
    NSInteger numRows = [tableView numberOfRowsInSection:numSections-1];
    
    if(indexPath.section==numSections-1 && indexPath.row==numRows-1) {
        NSLog(@"User tapped delete all; show popup confirmation before proceeding.");
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


@end
