//
//  StartCollectionViewController.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "StartCollectionViewController.h"
#import "PlayViewController.h"
#import "GenericCollectionViewCell.h"
#import "Constants.h"
#import "Game.h"
#import "UIImage+Additions.h"

#define MAX_TEAMS 2

@interface StartCollectionViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *playButton;

@end

@implementation StartCollectionViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        _selectedTeams = [NSMutableSet new];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [[Constants instance] LIGHT_BLUE];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:
     [UIImage imageWithGradientFrom:[UIColor colorWithWhite:1.0 alpha:0.9]
                                 to:[UIColor colorWithWhite:1.0 alpha:0.8]
                         withHeight:self.navigationController.navigationBar.frame.size.height]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    
    // Collection UI setup
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = YES;
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updatePlayButtonStatus];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_selectedTeams removeAllObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 && indexPath.section==0) {
        GenericCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NewTeamCellIdentifier
                                                                                    forIndexPath:indexPath];
        
        return cell;
    }
    
    else {
        TeamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TeamCellIdentifier
                                                                                 forIndexPath:indexPath];
        cell.delegate = self;
        
        [self configureTeamCell:cell
                   forIndexPath:indexPath
                       animated:NO];
        
        return cell;
    }
}

- (void) configureTeamCell:(TeamCollectionViewCell*)cell
              forIndexPath:(NSIndexPath*)indexPath
                  animated:(BOOL)animated;
{
    NSIndexPath *offsetIdxPath = [NSIndexPath indexPathForRow:indexPath.row-1
                                                    inSection:indexPath.section];
    Team *team = [self.fetchedTeamsController objectAtIndexPath:offsetIdxPath];
    
    [cell configureCellWithTeam:team];
    
    if([_selectedTeams containsObject:team]) {
        [cell setSelected:YES];
    }
    
    cell.moreButton.hidden = YES;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 && indexPath.section==0) {
        // Create a new team
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        [super showAlertForNewTeam];
    }
    
    else {
        if(_selectedTeams.count>MAX_TEAMS-1) {
            // User picked too many teams
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            [self showAlertForWrongNumberOfTeams];
        }
        
        else {
            // Add selected team to selected teams
            NSIndexPath *offsetIdxPath = [NSIndexPath indexPathForRow:indexPath.row-1
                                                            inSection:indexPath.section];
            Team *team = [self.fetchedTeamsController objectAtIndexPath:offsetIdxPath];
            [_selectedTeams addObject:team];
        }
    }
    
    [self updatePlayButtonStatus];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=0 || indexPath.section!=0) {
        NSIndexPath *offsetIdxPath = [NSIndexPath indexPathForRow:indexPath.row-1
                                                        inSection:indexPath.section];
        Team *team = [self.fetchedTeamsController objectAtIndexPath:offsetIdxPath];
        [_selectedTeams removeObject:team];
    }
    
    [self updatePlayButtonStatus];
}

- (void) updatePlayButtonStatus
{
    self.playButton.enabled = (_selectedTeams.count==MAX_TEAMS);
}

- (void) showAlertForWrongNumberOfTeams
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Whoops..."
                                                                             message:@"Please select two teams."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay"
                                                   style:UIAlertActionStyleDefault
                                                 handler:nil];
    [alertController addAction:okay];
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

- (IBAction)cancelNewGame:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
                                  sender:(id)sender
{
    if([identifier isEqualToString:SegueToPlayGameIdentifier] && _selectedTeams.count != MAX_TEAMS) {
        [self showAlertForWrongNumberOfTeams];
        return NO;
    }
    
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if([segue.identifier isEqualToString:SegueToPlayGameIdentifier]) {
        PlayViewController *playVC = [segue destinationViewController];
        playVC.currentGame = [Game newGameWithName:@"" andTeams:_selectedTeams.allObjects];
    }
}

@end
