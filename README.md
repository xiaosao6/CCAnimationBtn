
# CCAnimationBtn
A category of UIButton imitates the animation effect of favor button in DouYin App. 

一个UIButton分类，模仿抖音App中点赞按钮的动画效果

---
# CCAnimationBtn
-------------

### 效果:
![image](https://github.com/xiaosao6/CCAnimationBtn/blob/master/btn-anim.gif)

PS: 实际效果比gif要更流畅

### 示例:  
```oc
UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(60, 60, 150, 150)];
[btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:btn];
    
-(void)btnClicked:(UIButton *)btn{
    btn.ccFavorite = !btn.ccFavorite;
}
```

### 特性
- 使用Category实现，对`UIButton`无入侵
- 使用代码绘制样式，无需图片资源
- 可配置项: 线条数量、线条宽度、线条长度相对比例、中心icon相对比例、动画时长、渲染颜色等。

### 原理说明
绘制心形，使用UIBezierPath绘制二次曲线与弧线；

绘制放射线，使用CAShapeLayer结合mask绘制多个三角形图层；

动画主要使用CABasicAnimation进行缩放，位移，旋转，透明度等属性进行动画

### 使用方法
直接下载工程，引用`UIButton+CCFavoriteAnimation.h`，配置参数后即可使用

### 注意事项
- 使用了CASpringAnimation，需要iOS 9.0+

## License
none

