//
//  DetailViewController.m
//  读取通讯录
//
//  Created by dingdaifu on 15/8/7.
//  Copyright (c) 2015年 wangzhuoqun. All rights reserved.
//

#import "DetailViewController.h"
#import "model.h"

@interface DetailViewController ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIImagePickerController * picker;
@property (nonatomic, strong) UIActionSheet * actionSheet;
@property (nonatomic, strong) NSDictionary * dic;

@property (nonatomic, weak) IBOutlet UILabel * name;
@property (nonatomic, weak) IBOutlet UILabel * telephone;
@property (nonatomic, weak) IBOutlet UIImageView * headView;
@property (nonatomic, weak) IBOutlet UIImageView * littleImage;

-(IBAction)takeTelephone:(id)sender;
-(IBAction)back:(id)sender;
-(IBAction)saveImage:(id)sender;

@end

@implementation DetailViewController

-(NSDictionary *)dic
{
    if (!_dic) {
        _dic = [NSDictionary dictionary];
    }
    return _dic;
}

-(model *)model
{
    if (!_model) {
        _model = [[model alloc]init];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBaseContent];
    [self initImagePicker];
    [self setUpHeadImage];
}

-(void)setUpHeadImage
{
    if ([self.dic count]) {
        self.headView.image = nil;
    }else {
        
        NSString * path1 = [NSString stringWithFormat:@"%@/Library/image/%@.jpg",NSHomeDirectory(),self.model.name];
        NSData * data = [NSData dataWithContentsOfFile:path1];
        
        if (path1.length) {
            self.headView.image = [UIImage imageWithData:data scale:0.1];
        }
    }
}

-(void)setUpBaseContent
{
    self.name.text = self.model.name;
    self.telephone.text = self.model.telephoneNum;
}

-(void)initImagePicker
{
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.delegate = self;
    UITapGestureRecognizer * tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)];
    tapGest.delegate = self;
    [self.headView addGestureRecognizer:tapGest];
}

-(IBAction)saveImage:(id)sender
{
    UIImage *image= [self.dic objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSString *imageName = self.model.name;
    [self saveImg:imageName subPath:@"/Library/image/" imageObject:image];
}

-(void)saveImg:(NSString *)imageName subPath:(NSString *)subPath imageObject:(UIImage *)imageObject
{
    // 图片的二进制
    NSString *imgPrefix = @"";
    NSData *imgData = UIImageJPEGRepresentation(imageObject, 0.1);
    if (!imgData) {
        imgData=UIImagePNGRepresentation(imageObject);
        imgPrefix=@".png";
    } else {
        imgPrefix=@".jpg";
    }
    NSString *relativeImgPath = [NSString stringWithFormat:@"%@%@%@", subPath, imageName, imgPrefix];
    NSString *localImgStr=[NSHomeDirectory() stringByAppendingString:relativeImgPath];
    NSString *path=[NSHomeDirectory() stringByAppendingFormat:@"%@", subPath];
    NSError *err = nil;
    if ([[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err])
    {
        [imgData writeToFile:localImgStr options:NSDataWritingAtomic error:&err];
        if (err) {
            NSLog(@"保存图片失败：%@", err);
        } else {
            NSLog(@"保存图片成功");
        }
    } else {
        NSLog(@"创建目录失败:%@", err);
    }
}

-(IBAction)takeTelephone:(id)sender
{
    if (self.model.telephoneNum.length) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.model.telephoneNum];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selectImage
{
    self.actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
    self.actionSheet.delegate = self;
    [self.actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == 1) {
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        return;
    }
    [self presentViewController:self.picker animated:YES completion:nil];
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    return;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    
    self.dic = info;
    UIImage *image= [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
    if (image) {
        self.headView.image = nil;
    }

    self.headView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
