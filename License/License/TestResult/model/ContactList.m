//
//  LFShareFriend.m
//  快租
//
//  Created by 电信中国 on 2019/7/25.
//  Copyright © 2019年 LiuLinFei. All rights reserved.
//

#import "ContactList.h"

#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

typedef void(^uploadContactsCompletionBlock)(BOOL storage);

@interface ContactList ()

@property (nonatomic,strong)UIViewController * controller;
//上传通讯录成功 回调block
@property (nonatomic,copy)uploadContactsCompletionBlock uploadContactsBlock;

@end

@implementation ContactList

#pragma mark --- /用户授权 获取通讯录列表---

- (void)showContactListWithCompletion:(void(^)(BOOL success, NSDictionary *contacts))completion {
    __weak typeof(self) weakself = self;
    CNContactStore * contactStore = [[CNContactStore alloc] init];
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined)
    {//用户授权
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            __strong typeof(weakself) strongSelf = weakself;
            if (granted) {//允许
                NSMutableArray * contactArr = [self fetchContactWithContactStore:contactStore];//获取通讯录信息
                if (completion) completion(true, @{@"data":contactArr});
            }else{//拒绝
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf showContactAlertView];
                });
            }
        }];
    }else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        NSMutableArray * contactArr = [self fetchContactWithContactStore:contactStore];//获取通讯录信息
        if (completion) completion(true, @{@"data": contactArr});
    } else {
        [weakself showContactAlertView];
    }
}

// CNContactStore
- (NSMutableArray *)fetchContactWithContactStore:(CNContactStore *)contactStore {
    NSMutableArray * contactArr = [[NSMutableArray alloc] init];
    NSMutableDictionary * contactDic = [[NSMutableDictionary alloc] init];
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) {
        NSError * error = nil;
        //创建数组,必须遵守CNKeyDescriptor协议,放入相应的字符串常量来获取对应的联系人信息
        NSArray <id<CNKeyDescriptor>> *keysToFetch = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey];
        //创建获取联系人的请求
        CNContactFetchRequest * fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        //遍历查询
        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            if (!error) {
                NSString * tmpFirstName = contact.familyName;
                NSString * tmpLastName = contact.givenName;
                NSString * tmpPhone = ((CNPhoneNumber *)(contact.phoneNumbers.lastObject.value)).stringValue;
                tmpPhone = [tmpPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                [contactDic setObject:[NSString stringWithFormat:@"%@%@",tmpFirstName?:@"",tmpLastName?:@""] forKey:@"name"];
                [contactDic setObject:[NSString stringWithFormat:@"%@",tmpPhone] forKey:@"phone"];
                //判断手机号或者姓名是否为空
                BOOL empty = [self stringIsEmptyWithContactDict:contactDic];
                if (!empty) {
                    [contactArr addObject:[contactDic copy]];
                }
            }else{
            }
        }];
    } else {
        [self showContactAlertView];
    }
    
    return contactArr;
}

// 跳转到通讯录隐私设置页面
- (void)showContactAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"需开启通讯录权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionSet = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    //                FFLog(@"跳转设置成功");
                }];
            } else {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
    //    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionSet];
    //    [alert addAction:actionCancle];
    //    [alert showViewController:[UIApplication sharedApplication].keyWindow.rootViewController sender:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
}

#pragma mark --- privte method ---
// 判断字符串是否为空
- (BOOL)stringIsEmptyWithContactDict:(NSMutableDictionary *)contactDict {
    BOOL empty = NO;
    for (NSString * string in contactDict.allValues) {// 姓名或者手机号某一个为空即为YES 直接retyrn
        if ([string isKindOfClass:[NSNull class]] || string == nil || [string length] < 1) {
            empty = YES;
            break;
        }
    }
    return empty;
}

@end
