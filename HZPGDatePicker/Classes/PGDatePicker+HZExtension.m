//
//  PGDatePicker+HZExtension.m
//  ypxsq
//
//  Created by o888 on 2018/8/22.
//  Copyright © 2018年 o888. All rights reserved.
//

#import "PGDatePicker+HZExtension.h"
#import <objc/runtime.h>

static const char hz_userInfoKey;

@implementation PGDatePicker (HZExtension)

- (void)setHz_userInfo:(NSDictionary *)hz_userInfo {
    objc_setAssociatedObject(self, &hz_userInfoKey, hz_userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)hz_userInfo {
    return objc_getAssociatedObject(self, &hz_userInfoKey);
}

@end
