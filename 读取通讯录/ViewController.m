//
//  ViewController.m
//  读取通讯录
//
//  Created by dingdaifu on 15/8/7.
//  Copyright (c) 2015年 wangzhuoqun. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "myCell.h"
#import "model.h"
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSArray * tmpPeoples;
@property (nonatomic, strong) NSArray * indexArray;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) UISearchBar * searchBar;

@end

@implementation ViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indexArray = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    
    [self initTableView];
    [self ReadAllPeoples];
//    [self initSearchBar];
}

-(void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length) {
        for (int i = 0; i<self.dataArray.count; i++) {
            model * mymodel = self.dataArray[i];
            if ([mymodel.name hasPrefix:searchBar.text]) {
                [self.dataArray addObject:mymodel];
                [self.tableView reloadData];
            }
        }
    } else {
        [self.dataArray removeAllObjects];
        [self ReadAllPeoples];
    }
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 66;
    [self.view addSubview:self.tableView];
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"myCell" owner:self options:nil]lastObject];
    }
    
    cell.myModel = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    model * myModel = self.dataArray[indexPath.row];
    DetailViewController * detailVC = [[DetailViewController alloc]init];
    detailVC.model = myModel;
    
    [self presentViewController:detailVC animated:YES completion:nil];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{

    return index;
}

-(void)ReadAllPeoples
{
    //取得本地通信录名柄
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    ABAddressBookRef tmpAddressBook = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else {
        tmpAddressBook =ABAddressBookCreate();
    }
    //取得本地所有联系人记录
    if (tmpAddressBook==nil) {
        return ;
    };
    self.tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    
    for(id tmpPerson in self.tmpPeoples)
    {
        NSString* tmpFirstName = (NSString*)CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty));
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonLastNameProperty);
        NSString* middleName = (__bridge NSString*)ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonMiddleNameProperty);
        
        if (tmpLastName.length == 0) {
            tmpLastName = @"";
        }
        if (tmpFirstName.length == 0) {
            tmpFirstName = @"";
        }
        if (middleName.length == 0) {
            middleName = @"";
        }
        
        dict[@"name"] = [NSString stringWithFormat:@"%@%@%@",tmpLastName,middleName,tmpFirstName];
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            if (j==0) {
                dict[@"telephoneNum"] = tmpPhoneIndex;
            }
        }
        CFRelease(tmpPhones);
        model * myModel = [model instanceWithDictionary:dict];
        [self.dataArray addObject:myModel];
        
        
//        //获取的联系人单一属性:Nickname
//        NSString* tmpNickname = (NSString*)CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonNicknameProperty));
//        
//        //获取的联系人单一属性:Company name
//        NSString* tmpCompanyname = (NSString*)CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonOrganizationProperty));
//        
//        //获取的联系人单一属性:Job Title
//        NSString* tmpJobTitle= (NSString*)CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonJobTitleProperty));
//        
//        //获取的联系人单一属性:Department name
//        NSString* tmpDepartmentName = (NSString*)CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonDepartmentProperty));
//        
//        //获取的联系人单一属性:Email(s)
//        ABMultiValueRef tmpEmails = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonEmailProperty);
//        CFRelease(tmpEmails);
//        
//        //获取的联系人单一属性:Birthday
//        NSDate* tmpBirthday = (NSDate*)CFBridgingRelease(ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonBirthdayProperty));
//        //获取的联系人单一属性:Note
//        NSString* tmpNote = (__bridge NSString*)ABRecordCopyValue(CFBridgingRetain(tmpPerson), kABPersonNoteProperty);
    }
    
    //释放内存
    CFRelease(tmpAddressBook);
    [self.tableView reloadData];
}

@end
