//
//  Word.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "Word.h"
#import "Round.h"
#import "Constants.h"
#import "Model.h"

@implementation Word

@dynamic the_word;
@dynamic timestamp;
@dynamic round;

+ (Word*) newWordInRound:(Round*)round
{
    if(!round) {
        return nil;
    }
    
    Word *newWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word"
                                                  inManagedObjectContext:[[Model sharedManager] managedObjectContext]];
    
    newWord.the_word = @"asdf";
    newWord.timestamp = [NSDate new];
    newWord.round = round;
    
    [Model saveContext];
    
    return newWord;
}

@end
