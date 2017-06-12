//
//  AKStorageProvider.m
//  AK_test_app
//
//  Created by Alexey Kostyuchenko on 4/1/17.
//  Copyright © 2017 Alexey Kostyuchenko. All rights reserved.
//

#import "AKStorageProvider.h"

@implementation AKStorageProvider

+ (AKStorageProvider *)sharedInstance {
	static AKStorageProvider* sAKStorageProvider = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (nil == sAKStorageProvider) {
			sAKStorageProvider = [[AKStorageProvider alloc] init];
		}
	});

	return sAKStorageProvider;
}

- (id)init {
    if (self = [super init]) {
        self.persistentContainer = [[NSPersistentContainer alloc]
            initWithName:@"AK_JSON_data_test"];
        [self.persistentContainer loadPersistentStoresWithCompletionHandler:
            ^(NSPersistentStoreDescription *description, NSError *error) {
            if (error != nil) {
                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                abort();
            }
        }];
    }
    return self;
}

- (BOOL)saveContext {
    NSError *error = nil;
    if (self.persistentContainer.viewContext != nil) {
        if ([self.persistentContainer.viewContext hasChanges] &&
            ![self.persistentContainer.viewContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    return error == nil;
}

@end
