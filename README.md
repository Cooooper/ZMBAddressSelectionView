# ZMBAddressSelectionView
> 地址选择控件，仿京东收货地址选择控件，支持网络获取下一级地址列表

-----

#### 使用步骤

----
1、把 ZMBAddressSelectionView 添加到你要显示的地方。

2、发起网络请求拿到全部省份，执行这个方法填充省份数据
`- (void)reloadProvinceTable:(NSArray *)provinces;`

3、实现这个回调方法（当点击省份的时候会回调），得到已选定省的 Id (provinceId)
`- (void)addressSelectionView:(ZMBAddressSelectionView *)selectionView willSelectedProvince:(NSString *)provinceId;`

4、通过这个 provinceId 发起网络请求获取城市列表，执行这个方法填充城市数据
`- (void)reloadProvinceTable:(NSArray *)provinces;`

5、实现这个回调（当点击城市的时候会回调），得到已选定城市的 Id (cityId)

`- (void)addressSelectionView:(ZMBAddressSelectionView *)selectionView willSelectedCity:(NSString *)cityId;

6、通过 cityId 发起网络请求获取地区列表，执行这个方法填充地区数据
`- (void)reloadDistrictTable:(NSArray *)districts;`

7、这个 block 在点击地区后会回调，得到 fullName
`void(^addressSelectionFinished)(NSString *Id,NSString *fullName)`




