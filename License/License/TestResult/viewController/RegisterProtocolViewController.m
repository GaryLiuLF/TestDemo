//
//  LoginProtocolViewController.m
//  License
//
//  Created by 电信中国 on 2019/10/18.
//  Copyright © 2019 wei. All rights reserved.
//

#import "RegisterProtocolViewController.h"

#import <WebKit/WebKit.h>
#import <Masonry.h>

@interface RegisterProtocolViewController () <WKNavigationDelegate, UIScrollViewDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressBar;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation RegisterProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithData];
    
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    [self.refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.refreshButton.backgroundColor = [UIColor clearColor];
    self.refreshButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.webView = [[WKWebView alloc] init];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    self.progressBar = [[UIProgressView alloc] init];
    self.progressBar.backgroundColor = [UIColor clearColor];
    self.progressBar.trackTintColor = [UIColor clearColor];
    self.progressBar.progressTintColor = [UIColor blueColor];
    [self.webView addSubview:self.progressBar];
    [self.webView addObserver:self forKeyPath:@"ProgressStatus" options:NSKeyValueObservingOptionNew context:nil];
    
    [self setupLayout];
}

- (void)initWithData {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor clearColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"标题";
}

- (void)setupLayout {
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.webView);
        make.top.equalTo(self.webView);
        make.height.mas_equalTo(2);
    }];
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"ProgressStatus"];
}

# pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.webView && [keyPath isEqualToString:@"ProgressStatus"]) {
        CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (_progressBar) {
            _progressBar.progress = progress;
            if (progress == 1.0) {
                _progressBar.progress = 0;
            }
        }
    }
}

@end
