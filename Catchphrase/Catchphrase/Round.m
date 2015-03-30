//
//  Round.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "Round.h"
#import "Game.h"
#import "Team.h"
#import "Word.h"
#import "Model.h"
#import "Constants.h"

@implementation Round

@dynamic round_started;
@dynamic round_finished;
@dynamic round_id;
@dynamic game;
@dynamic words;
@dynamic losingPlayer;

+ (Round*) roundWithID:(NSString*)round_id
{
    if([round_id isEqualToString:@""] || !round_id || [round_id isEqual:[NSNull null]]) {
        return nil;
    }
    
    Round *newRound = (Round*)[[Model sharedManager] fetchObjectWithName:@"Round"
                                                                  andKey:@"round_id"
                                                                  andVal:round_id];
    return newRound;
}

+ (Round*) newRoundInGame:(Game*)game
{
    if(!game) {
        return nil;
    }
    
    Round *round = [NSEntityDescription insertNewObjectForEntityForName:@"Round"
                                                 inManagedObjectContext:[[Model sharedManager] managedObjectContext]];
    
    round.game = game;
    round.round_started = [NSDate new];
    round.round_id = [NSString stringWithFormat:@"%lu", [round.round_started hash]];
    
    [Model saveContext];
    
    return round;
}

@end
