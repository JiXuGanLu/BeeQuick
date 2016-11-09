# BeeQuick
仿爱鲜蜂3.5版，请在不低于10.0版的模拟器或真机下运行. 由于没有官方接口文档, 所以抓取了官方app接收的数据存储在coding上进行请求.

基本达成官方的UI效果和逻辑, 在功能上使用SQLite+FMDB实现了 商品清单/分类/排序/购物车/商品收藏/地址管理/自提点设置 等功能和数据本地持久化.
所用框架:AFN/FMDB/MJRefresh/SVPHud/YYKit/Masonry

# 由于coding网站请求数据总抽风, 很容易出现请求超时, 如果运行时发现程序内容少于示例gif或者有空白(主要是home页), 请刷新或多尝试几次返回重新进入.
墙裂建议程序进入home页之后先下拉刷新几次=。=

gif存放地址：https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git

# launch
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/launch-min.gif)
navigationbar的渐变效果是新建navbar的分类, 利用运行时插入一个coverview;

# 总体结构
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/page.gif)

# home
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/home-1-min.gif)
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/home-2-min.gif)
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/home-3-min.gif)
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/home-4-min.gif)

# superMarket
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/superMarket-min.gif)

# shopCart
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/shopCartAddress.gif)
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/shopCartEdit-min.gif)
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/shopCartCheckOut-min.gif)

# mine
![image](https://coding.net/u/YiBaZhuangYuan/p/BeeQuickGif/git/raw/master/mine.gif)
