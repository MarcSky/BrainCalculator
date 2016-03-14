//
//  LocalMemory.h
//  calculator
//
//  Created by Levan Gogohia on 14.02.16.
//  Copyright © 2016 Levan Gogohia. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const valueKey;

@interface LocalMemory : NSObject
+(LocalMemory *) singleton;
-(void) saveObject:(NSString*) string;
-(NSString*) getObject;
@end
