//
//  Word.h
//  Catchphrase
//
//  Created by Nicholas Gerard on 3/30/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Round;

@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * the_word;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) Round *round;

+ (Word*) newWordInRound:(Round*)round;

@end
