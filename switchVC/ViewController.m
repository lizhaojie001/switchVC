//
//  RuralmarketController.m
//  YN12316
//
//  Created by 街路口等你 on 17/4/18.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "ViewController.h"
#import "UIView+ZJExtension.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIView * bottomView;
@property (nonatomic,weak) UIButton * selectedButton;
@property (nonatomic,strong) NSArray * DataArr;
@property (weak, nonatomic) UIScrollView *contentView;
@property (weak,nonatomic)UIView * titlesView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  设置自控制器
     */
    [self setupChildViewControllers];
    //设置内容视图
    [self setupScrollView];
    /**
     *  设置头部
     */
    [self setTitleView];
    // Do any additional setup after loading the view.
}
/**
 *  设置titleView
 */
- (void)setTitleView{
    
    NSArray * titles = @[@"供应",@"求购",@"找对象",@"免费发布"];
    
    //设置
    CGFloat SW =self.view.bounds.size.width;
    UIView * v = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SW, 44)];
    //生成button
    v.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    CGFloat y = 0;
    CGFloat W = SW/titles.count*1.0;
    CGFloat H = v.frame.size.height;
    
    
    for (int i =0;  i< titles.count; i ++) {
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setFrame:CGRectMake(i*W, y, W, H)];
        [button1 setTitle:titles[i] forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:button1];
        if (!i) {
            button1.selected =YES;
            self.selectedButton = button1;
        }
        
    }
    
    
    
    UIView * bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor redColor];
    bottomView.height= 2;
    bottomView.width = self.selectedButton.width;
    bottomView.centerX= self.selectedButton.centerX;
    bottomView.y = CGRectGetMaxY(self.selectedButton.frame)-2;
    [v addSubview:bottomView];
    [self.view addSubview:v];
    [self switchController:0];
    self.bottomView = bottomView;
    self.titlesView =v;
}
-(void)click:(UIButton*)button{
    self.selectedButton.selected = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.centerX = button.centerX;
    }];
    //self.bottomView.centerX - self.lastButton.centerX  <=0 ?(self.tag=1):(self.tag=0);
    button.selected = YES;
    
    self.selectedButton = button;
    //    [self getData];
    int index = (int)[self.titlesView.subviews indexOfObject:button];
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.frame.size.width, self.contentView.contentOffset.y) animated:YES];
}

/**
 *  设置内容视图
 */
-(void)setupScrollView{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    
    contentView.frame = self.view.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.delegate = self;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.pagingEnabled = YES;
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    [self.view addSubview:contentView];
    self.contentView = contentView;
}
/**
 *  设置自控制器
 */

-(void)setupChildViewControllers{
    UITableViewController * supply = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    supply.view.backgroundColor = [UIColor redColor];
    UITableViewController * buy = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    buy.view.backgroundColor = [UIColor greenColor];
    UITableViewController * miai = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    miai.view.backgroundColor = [UIColor blackColor];
    UIViewController * publish = [[UIViewController alloc]init];
    publish.view.backgroundColor = [UIColor orangeColor];
    [self addChildViewController:supply];
    [self addChildViewController:buy];
    [self addChildViewController:miai];
    [self addChildViewController:publish];
    
}

/**
 *  切换视图
 */

- (void)switchController:(int)index
{
    UIViewController *vc = self.childViewControllers[index];
    vc.view.y = 0;
    vc.view.width = self.contentView.width;
    vc.view.height = self.contentView.height;
    vc.view.x = vc.view.width * index;
    [self.contentView addSubview:vc.view];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self click:self.titlesView.subviews[index]];
    [self switchController:index];
}

- (void)scrollViewDidEndScrollingAnimation:(nonnull UIScrollView *)scrollView
{
    [self switchController:(int)(scrollView.contentOffset.x / scrollView.frame.size.width)];
}
@end
