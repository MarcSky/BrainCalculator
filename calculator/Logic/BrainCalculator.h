//
//  BrainCalculator.h
//  calculator
//
//  Created by Levan Gogohia on 28.02.16.
//  Copyright © 2016 Levan Gogohia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrainCalculator : NSObject
@property (nonatomic, strong) NSMutableArray *numberResultsStack;
+ (NSNumber *)calculateInfix:(NSString *)string;
@end
