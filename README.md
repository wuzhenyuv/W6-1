# 期权demo (Kovan测试链)
1: 部署期权token
hash:0x166ae0c94dc4f180ccd594bc847dc2b805982ef0e9f00456a6fb807b84118e11
<img width="943" alt="image" src="https://user-images.githubusercontent.com/33890215/161414245-5e3088d3-567f-4433-9946-e1a5de99bc7d.png">

2: 部署期权合约
hash:0x036f9496bc2ef9e37f62743773f8519c6cb2b2d4a64e6cd4917c53fe1c9d89da
<img width="931" alt="image" src="https://user-images.githubusercontent.com/33890215/161414284-73e1d40d-143a-43db-8a78-cac71ffb988d.png">

3:根据转入的标的（Bat）发行期权Token，然后在uniswap上添加期权代币opt和用于购买的代币atToken的流动性池
hash:0x37736470579c72cb1da0828a0a7dc7cf6884512b21d1e0a94b06b753c0422cfc
<img width="1113" alt="image" src="https://user-images.githubusercontent.com/33890215/161414377-49159179-99c5-4260-a2d0-7e865889ba54.png">

4:在uniswap上通过atToken购买期权代币opt
hash:0xf0ba2628be57725f9e3d8faec64fbb873d485448e4ed0c23028613c88a8b3929
<img width="1096" alt="image" src="https://user-images.githubusercontent.com/33890215/161414447-3c28b856-0e22-409b-85ff-1da662c41475.png">

5:行权在到期日当天，通过指定的价格兑换出标的资产，并销毁期权Token
hash:0x14e705763d20ea6b6a21e80d83b33b2c71e5871f74b16d56509274cf24b33e18
<img width="997" alt="image" src="https://user-images.githubusercontent.com/33890215/161414496-b18dd688-57f7-42eb-b203-c1b918e637a8.png">

6:过期销毁所有期权Token,移除流动性，赎回标的
hash:0x13cfe36ba08aed9e2a22e64fb2d3a46602742e9d505fa74d39fad87539970ffd
<img width="1074" alt="image" src="https://user-images.githubusercontent.com/33890215/161414525-864a0412-8138-4cfa-8ab6-922f4afca4fc.png">









