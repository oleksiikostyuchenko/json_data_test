//
//  NSDate+AKNSDateExtension.h
//  AK_test_app
//
//  Created by Alexey Kostyuchenko on 4/1/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AKNSDateExtension)

+ (NSDate *)dateWithString:(NSString *)aDateString;
+ (NSString *)stringWithDate:(NSDate *)aDate;

@end
