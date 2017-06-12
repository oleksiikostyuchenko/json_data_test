//
//  NSDate+AKNSDateExtension.m
//  AK_test_app
//
//  Created by Alexey Kostyuchenko on 4/1/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import "NSDate+AKNSDateExtension.h"

@implementation NSDate (AKNSDateExtension)

+ (NSDate *)dateWithString:(NSString *)aDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:aDateString];
}

+ (NSString *)stringWithDate:(NSDate *)aDate {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"HH:mm";
	return [dateFormatter stringFromDate:aDate];
}

@end
