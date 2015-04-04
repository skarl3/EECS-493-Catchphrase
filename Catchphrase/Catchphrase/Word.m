//
//  Word.m
//  Catchphrase
//
//  Created by Nicholas Gerard on 4/3/15.
//  Copyright (c) 2015 eecs493. All rights reserved.
//

#import "Word.h"

static Word* sharedClient = nil; // Singleton object

@interface Word()

@property (strong, nonatomic) NSArray *easyWords;
@property (strong, nonatomic) NSArray *mediumWords;
@property (strong, nonatomic) NSArray *hardWords;

@end

@implementation Word

- (id) init
{
    if (self = [super init]) {
        // Let's just keep this all in memory...
        _easyWords = @[ @"baby", @"door", @"banana", @"finger", @"fence", @"big", @"swimming pool", @"sun", @"church", @"yo-yo", @"boy", @"bag", @"alligator", @"mouse", @"birthday", @"winter", @"beach", @"tree", @"teacher", @"king", @"telephone", @"eye", @"water", @"jelly", @"balloon", @"toothbrush", @"pants", @"mom", @"dad", @"body", @"bike", @"motorcycle", @"toilet paper", @"baseball", @"pig", @"lawn mower", @"fire", @"school", @"belt", @"pajamas", @"mud", @"ice cream cone", @"arm", @"drums", @"spider", @"shark", @"seashell", @"computer", @"grandma", @"pillow", @"kite", @"homework", @"ladybug", @"bed", @"bird", @"gum", @"book", @"dress", @"queen", @"puppy", @"happy", @"doctor", @"frog", @"blanket", @"popsicle", @"pen", @"sandwich", @"boat", @"dad", @"lunchbox", @"ice", @"bottle", @"elbow", @"penny", @"broom", @"dog", @"rose", @"picnic", @"chair", @"duck", @"hair", @"zoo", @"party", @"piano", @"key", @"apple", @"chalk", @"park", @"clock", @"pencil", @"hill", @"flag", @"lollipop", @"candle", @"flower", @"basketball", @"hug", @"clown", @"paper", @"mountain", @"nose", @"cow", @"grown-up", @"grass", @"rainbow", @"hide and seek", @"pocket", @"grape", @"cowboy", @"doll", @"forehead", @"football", @"crayon", @"desk", @"TV", @"bedtime", @"hopscotch", @"dump truck", @"cold", @"paint", @"ear", @"moon", @"tuba", @"singer", @"race", @"candy", @"student", @"day", @"jump", @"hurt", @"laundry", @"blue", @"sad", @"old", @"guitar", @"athlete", @"night", @"knee", @"wedding", @"bat"];
        _mediumWords = @[ @"taxi cab", @"standing ovation", @"alarm clock", @"tool", @"banana peel", @"flagpole", @"money", @"wallet", @"ballpoint pen", @"sunburn", @"wedding ring", @"spy", @"baby sitter", @"aunt", @"acne", @"bib", @"puzzle piece", @"pawn", @"astronaut", @"tennis shoes", @"blue jeans", @"twig", @"outer space", @"banister", @"batteries", @"doghouse", @"campsite", @"plumber", @"bedbug", @"throne", @"tiptoe", @"log", @"mute", @"pogo stick", @"stoplight", @"ceiling fang", @"bedspread", @"bite", @"stove", @"windmill", @"nightmare", @"stripe", @"spring", @"wristwatch", @"eat", @"matchstick", @"gumball", @"bobsled", @"bonnet", @"flock", @"sprinkler", @"living room", @"laugh", @"snuggle", @"sneeze", @"bud", @"elf", @"headache", @"slam dunk", @"Internet", @"saddle", @"ironing board", @"bathroom scale", @"kiss", @"shopping cart", @"shipwreck", @"funny", @"glide", @"lamp", @"candlestick", @"grandfather", @"rocket", @"home movies", @"seesaw", @"rollerblades", @"smog", @"grill", @"goblin", @"coach", @"claw", @"cloud", @"shelf", @"recycle", @"glue stick", @"Christmas carolers", @"front porch", @"earache", @"robot", @"foil", @"rib", @"robe", @"crumb", @"paperback", @"hurdle", @"rattle", @"fetch", @"date", @"iPod", @"iPad", @"dance", @"cello", @"flute", @"dock", @"prize", @"dollar", @"puppet", @"brass", @"firefighter", @"huddle", @"easel", @"pigpen", @"bunk bed", @"bowtie", @"fiddle", @"dentist", @"baseboards", @"letter opener", @"photographer", @"magic", @"Old Spice", @"monster"];
        _hardWords = @[ @"whatever", @"buddy", @"sip", @"chicken coop", @"blur", @"chime", @"bleach", @"clay", @"blossom", @"cog", @"twitterpated", @"wish", @"through", @"feudalism", @"whiplash", @"cot", @"blueprint", @"beanstalk", @"think", @"cardboard", @"darts", @"inn", @"Zen", @"crow's nest", @"BFF", @"sheriff", @"tiptop", @"dot", @"bob", @"garden hose", @"blimp", @"dress shirt", @"reimbursement", @"capitalism", @"step daughter", @"applause", @"jig", @"jade", @"blunt", @"application", @"rag", @"squint", @"intern", @"sow's ear", @"brainstorm", @"sling", @"half", @"pinch", @"leak", @"skating rink", @"jog", @"jammin'", @"shrink ray", @"dent", @"scoundrel", @"escalator", @"cell phone charger", @"kitchen knife set", @"sequins", @"ladder rung", @"flu", @"scuff mark", @"mast", @"sash", @"modern", @"ginger", @"clockwork", @"mess", @"mascot", @"runt", @"chain", @"scar tissue", @"suntan", @"pomp", @"scramble", @"sentence", @"first mate", @"cuff", @"cuticle", @"fortnight", @"riddle", @"spool", @"full moon", @"forever", @"rut", @"hem", @"new", @"freight train", @"diver", @"fringe", @"festival", @"humidifier", @"handwriting", @"dawn", @"dimple", @"gray hairs", @"hedge", @"plank", @"race", @"publisher", @"fizz", @"gem", @"ditch", @"wool", @"plaid", @"fancy", @"ebony and ivory", @"feast", @"Murphy's Law", @"billboard", @"midsummer", @"advertisement", @"inconceivable", @"tide", @"midsummer", @"population", @"growth", @"my", @"elm", @"organ", @"flannel", @"hatch", @"booth", @"stand"];
    }
    return self;
}

// Singleton

+ (id) wordManager
{
    if (!sharedClient) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedClient = [[self alloc] init];
        });
    }
    return sharedClient;
}

// Word generator methods

- (NSString*) anyWord
{
    NSInteger cat = arc4random() % 3;
    NSArray *selected = (cat==0) ? _easyWords : (cat==1) ? _mediumWords : _hardWords;
    NSInteger word = arc4random() % selected.count;
    return [selected objectAtIndex:word];
}

- (NSString*) wordFromEasy:(BOOL)easy
                 andMedium:(BOOL)medium
                   andHard:(BOOL)hard
{
    if(!easy && !medium && !hard) {
        return nil;
    }
    
    else if(easy && medium && hard ) {
        return [self anyWord];
    }
    
    else {
        NSMutableArray *dicts = [NSMutableArray new];
        if(easy) [dicts addObject:_easyWords];
        if(medium) [dicts addObject:_mediumWords];
        if(hard) [dicts addObject:_hardWords];
        
        NSInteger cat = arc4random() % dicts.count;
        NSArray *selected = [dicts objectAtIndex:cat];
        NSInteger word = arc4random() % selected.count;
        return [selected objectAtIndex:word];
    }
}

@end
