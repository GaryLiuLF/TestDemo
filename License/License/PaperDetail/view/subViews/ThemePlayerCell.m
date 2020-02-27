//
//  ThemePlayerCell.m
//  License
//
//  Created by wei on 2019/7/11.
//  Copyright © 2019年 wei. All rights reserved.
//

#import "ThemePlayerCell.h"
#import <AVFoundation/AVFoundation.h>
@interface ThemePlayerCell()
@property (nonatomic,strong)UIImageView*loadView;
@property (nonatomic,strong)UIView*topView;
@property (nonatomic,strong)AVPlayer *player;//播放器对象
@property (nonatomic,strong)AVPlayerItem *currentPlayerItem;
@property (nonatomic,strong)AVPlayerLayer *avLayer;
@end
@implementation ThemePlayerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.loadView =[[ UIImageView alloc] initWithImage:BImage(@"loading")];
        self.loadView.frame = CGRectMake(23, 15, BBWidth-23*2, (BBWidth-23*2)*562/1000.f);
        [self.contentView addSubview:self.loadView];
        
        
        self.topView = [[UIView alloc] initWithFrame:self.loadView.frame];
        self.topView.backgroundColor = KClearColor;
        [self.contentView addSubview:self.topView];
        
        UIView*blockv = [[UIView alloc] initWithFrame:self.topView.bounds];
        blockv.backgroundColor = kblock;
        blockv.alpha = 0.4;
        [self.topView addSubview:blockv];
        
        UIImage*playicon=BImage(@"playicon");
        UIImageView*iconV=[[UIImageView alloc] initWithFrame:CGRectMake(self.topView.width/2-18, self.topView.height/2-20, 40, 40)];
        iconV.image = playicon;
        [self.topView addSubview:iconV];
        [self.topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlay:) name:@"ThemePlayerCell_stop" object:nil];
    }
    return self;
}
- (void)tapAction{
    if(_player){
        [_player play];
        if(self.topView.hidden==NO){
            self.topView.hidden=YES;
        }
    }
}

- (void)setModel:(ThemeItem *)model{
    if(_model==model && _player) return;
    _model = model;
    [self clear];
    _avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    _avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _avLayer.frame = CGRectMake(0, 0, BBWidth-23*2, (BBWidth-23*2)*562/1000.f);
    [self.loadView.layer addSublayer:_avLayer];

    [self.player play];
    [self.currentPlayerItem seekToTime:kCMTimeZero];
    [self.player pause];
    if(self.topView.hidden==YES){
        self.topView.hidden=NO;
    }
}

- (AVPlayerItem*)currentPlayerItem{
    if(!_currentPlayerItem){
        //http://iosurl.titrol.cn/40091.mp4
        NSString*last = [_model.value substringWithRange:NSMakeRange(_model.value.length-9, 5)];
        NSString*url = [NSString stringWithFormat:@"http://iosurl.titrol.cn/%@.mp4",last];
        _currentPlayerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    }
    return _currentPlayerItem;
}
- (AVPlayer*)player{
    if(!_player){
        _player = [[AVPlayer alloc] initWithPlayerItem:self.currentPlayerItem];
    }
    return _player;
}
- (void)videoPlayEnd:(NSNotification*)n{
    if (![[n object] isEqual:self.player.currentItem]) {
        return;
    }
    AVPlayerItem * p = [n object];
    [p seekToTime:kCMTimeZero];
    [self.player pause];
    if(self.topView.hidden==YES){
        self.topView.hidden=NO;
    }
}
- (void)stopPlay:(NSNotification*)n{
    if(_player){
        [_player pause];
        if(self.topView.hidden==YES){
            self.topView.hidden=NO;
        }
    }
}
- (void)clear;{
    if(_avLayer){
        [_avLayer removeFromSuperlayer];
        _avLayer = nil;
        _currentPlayerItem = nil;
        _player = nil;
    }
    if(_currentPlayerItem){
        [_currentPlayerItem cancelPendingSeeks];
        [_currentPlayerItem.asset cancelLoading];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (CGFloat)cellHightWithModel:(ThemeItem*)model;{
    //2074 922
    return (BBWidth-23*2)*562/1000.f+30;
}


@end
