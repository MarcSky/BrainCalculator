//
//  LocalMemory.m
//  calculator
//
//  Created by Levan Gogohia on 14.02.16.
//  Copyright © 2016 Levan Gogohia. All rights reserved.
//

#import "LocalMemory.h"

NSString * const valueKey = @"infoString";

@implementation LocalMemory
+(LocalMemory *) singleton{
    static LocalMemory *singletonObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singletonObject = [[self alloc] init];
    });
    return singletonObject;
}

-(void) saveObject:(NSString*) string {
    [[NSUserDefaults standardUserDefaults] setValue:string forKey:valueKey];
}

-(NSString*) getObject {
    return [[NSUserDefaults standardUserDefaults] objectForKey:valueKey];
}

@end
