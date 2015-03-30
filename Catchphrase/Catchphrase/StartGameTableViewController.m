//
//  StartGameTableViewController.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "StartGameTableViewController.h"
#import "Constants.h"
#import "Model.h"
#import "Team.h"
#import "Game.h"

@interface StartGameTableViewController ()

@end

@implementation StartGameTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UI setup
    self.tableView.backgroundColor = [[Constants instance] LIGHT_BG];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (IBAction)cancelNewGame:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}


@end
