//
//  Team.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "Team.h"
#import "Game.h"
#import "Round.h"
#import "Model.h"
#import "Constants.h"

@implementation Team

@dynamic team_name;
@dynamic team_desc;
@dynamic team_id;
@dynamic wonGames;
@dynamic lostGames;
@dynamic inProgressGames;
@dynamic lostRounds;

+ (Team*) teamWithID:(NSString*)team_id
{
    if([team_id isEqualToString:@""] || !team_id || [team_id isEqual:[NSNull null]]) {
        return nil;
    }
    
    Team *newTeam = (Team*)[[Model sharedManager] fetchObjectWithName:@"Team"
                                                               andKey:@"team_id"
                                                               andVal:team_id];
    return newTeam;
}

+ (Team*) newTeamWithName:(NSString*)name
           andDescription:(NSString*)description
{
    Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team"
                                               inManagedObjectContext:[[Model sharedManager] managedObjectContext]];
    
    if(name) {
        team.team_name = name;
    }
    
    if(description) {
        team.team_desc = description;
    }
    
    team.team_id = [NSString stringWithFormat:@"%lu", [[NSDate new] hash]];
    
    [Model saveContext];
    
    return team;
}

@end
