//
//  BrainCalculator.m
//  calculator
//
//  Created by Levan Gogohia on 28.02.16.
//  Copyright © 2016 Levan Gogohia. All rights reserved.
//

#import "BrainCalculator.h"

typedef NS_ENUM(NSInteger, BrainCalculatorOperator) {
    BrainCalculatorNotOperator = -1,
    BrainCalculatorAddition = 0,
    BrainCalculatorSubtraction,
    BrainCalculatorMultiplication,
    BrainCalculatorDivision,
    BrainCalculatorOpenParan = 100,
    BrainCalculatorCloseParen
};

@implementation BrainCalculator

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    _numberResultsStack = [NSMutableArray new];
    return self;
}

+ (NSNumber *)calculateInfix:(NSString *)string { //Главная функция
    BrainCalculator *calculator = [BrainCalculator new];
    NSArray *stackify = [[calculator convertInfixToRPN:string] componentsSeparatedByString:@" "];
    NSLog(@"НОВОЕ %@",[calculator convertInfixToRPN:string]);
    return [calculator calculate:stackify error:nil];
}

+ (BOOL)isValidInstruction:(NSString *)instruction {
    static NSRegularExpression *regex;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z!@#$%^&();|<>\"',?\\\\]" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    return !([regex numberOfMatchesInString:instruction options:0 range:NSMakeRange(0, [instruction length])]);
}

- (NSNumber *)calculate:(NSArray *)numbers error:(NSError * __autoreleasing *)error {
    for (NSString *value in numbers) {
        BrainCalculatorOperator operator = [self operatorFromString:value];
        if (operator == BrainCalculatorNotOperator) { 
            [self pushValue:value];
        } else {
            [self performOperator:operator];
        }
    }
    
    if ([self.numberResultsStack count] > 1) { 
        return nil;
    }
    return [self popValue];
}


- (BrainCalculatorOperator)operatorFromString:(NSString *)string {
    if (!string || [string length] > 1) {
        return BrainCalculatorNotOperator;
    }
    const char *stringAsChar = [string cStringUsingEncoding:[NSString defaultCStringEncoding]];
    switch (stringAsChar[0]) {
        case '+':
            return BrainCalculatorAddition;
            break;
        case '-':
            return BrainCalculatorSubtraction;
            break;
        case '/':
            return BrainCalculatorDivision;
            break;
        case '*':
            return BrainCalculatorMultiplication;
            break;
        case '(':
            return BrainCalculatorOpenParan;
            break;
        case ')':
            return BrainCalculatorCloseParen;
            break;
        default:
            break;
    }
    return BrainCalculatorNotOperator;
}

- (void)performOperator:(BrainCalculatorOperator)operator { // 5 / 0
    double firstNumber = [[self popValue] doubleValue];
    double previousNumber = [[self popValue] doubleValue];
    
    double result = 0.f;
    switch (operator) {
        case BrainCalculatorAddition:
            result = previousNumber + firstNumber;
            break;
        case BrainCalculatorSubtraction:
            result = previousNumber - firstNumber;
            break;
        case BrainCalculatorMultiplication:
            result = previousNumber * firstNumber;
            break;
        case BrainCalculatorDivision:
            result = previousNumber / firstNumber;
            break;
        default:
            break;
    }
    
//    NSLog(@"new result %f", result);
    [self pushValue:[NSString stringWithFormat:@"%f", result]];
}

- (void)pushValue:(id)value {
    [self.numberResultsStack addObject:value];
}

- (id)popValue {
    id value = [self.numberResultsStack lastObject];
    [self.numberResultsStack removeLastObject];
    return value;
}

- (NSString *)convertInfixToRPN:(NSString *)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *operatorStack = [NSMutableArray new];
    NSMutableString *numberString = [NSMutableString string];
    BOOL __block lastWasOperator = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        
        BrainCalculatorOperator operator = [self operatorFromString:substring];
        if (operator == BrainCalculatorNotOperator) {
            if (lastWasOperator == YES) {
                [numberString appendString:@" "];
            }
            [numberString appendString:substring];
            lastWasOperator = NO;
        } else {
            BrainCalculatorOperator topStackOperator = [self operatorFromString:[operatorStack lastObject]];
            while ((operator == BrainCalculatorCloseParen && topStackOperator != BrainCalculatorOpenParan) || (topStackOperator != BrainCalculatorNotOperator && (operator == BrainCalculatorAddition || operator == BrainCalculatorSubtraction) && (topStackOperator == BrainCalculatorMultiplication || topStackOperator == BrainCalculatorDivision))) {
                
                [numberString appendString:@" "];
                [numberString appendString:[operatorStack lastObject]];
                [operatorStack removeLastObject];
                topStackOperator = [self operatorFromString:[operatorStack lastObject]];
                if (topStackOperator == BrainCalculatorOpenParan && operator == BrainCalculatorCloseParen) {
                    [operatorStack removeLastObject];
                }
            }
            if (operator != BrainCalculatorCloseParen) {
                [operatorStack addObject:substring];
            }
            lastWasOperator = YES;
        }
    }];
    
    while ([operatorStack count]) {
        [numberString appendString:@" "];
        [numberString appendString:[operatorStack lastObject]];
        [operatorStack removeLastObject];
    }
    return numberString;
}

@end