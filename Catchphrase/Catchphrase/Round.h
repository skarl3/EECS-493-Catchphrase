//
//  Round.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Team, Word;

@interface Round : NSManagedObject

@property (nonatomic, retain) NSDate * round_started;
@property (nonatomic, retain) NSDate * round_finished;
@property (nonatomic, retain) NSString * round_id;
@property (nonatomic, retain) Game *game;
@property (nonatomic, retain) NSSet *words;
@property (nonatomic, retain) Team *losingPlayer;

+ (Round*) roundWithID:(NSString*)round_id;
+ (Round*) newRoundInGame:(Game*)game;

@end

@interface Round (CoreDataGeneratedAccessors)

- (void)addWordsObject:(Word *)value;
- (void)removeWordsObject:(Word *)value;
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;

@end
