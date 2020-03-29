#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
sed -i 's/192.168.1.1/192.168.0.254/g' package/base-files/files/bin/config_generate

#添加自定义组件
git clone https://github.com/sypopo/luci-theme-atmaterial.git package/lean/luci-theme-atmaterial
git clone https://github.com/rufengsuixing/luci-app-adguardhome.git package/luci-app-adguardhome
git clone https://github.com/sypopo/luci-theme-argon-mc.git package/luci-theme-argon-mc
git clone https://github.com/rufengsuixing/luci-app-onliner.git package/luci-app-onliner
git clone https://github.com/lisaac/luci-app-diskman package/luci-app-diskman
mkdir -p package/parted && cp -i package/luci-app-diskman/Parted.Makefile package/parted/Makefile
mkdir -p package/lean/smartdns && wget -P package/lean/smartdns https://raw.githubusercontent.com/openwrt/packages/master/net/smartdns/Makefile
git clone https://github.com/Apocalypsor/luci-app-smartdns.git package/lean/luci-app-smartdns

#修复核心及添加温度显示
sed -i 's|pcdata(boardinfo.system or "?")|luci.sys.exec("uname -m") or "?"|g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm
sed -i 's/or "1"%>/or "1"%> ( <%=luci.sys.exec("expr `cat \/sys\/class\/thermal\/thermal_zone0\/temp` \/ 1000") or "?"%> \&#8451; ) /g' feeds/luci/modules/luci-mod-admin-full/luasrc/view/admin_status/index.htm

#修改机器名称
sed -i 's/OpenWrt/RaspberryPi3/g' package/base-files/files/bin/config_generate

#添加nfs
cp -rf ../luci-app-nfs package/lean/

# Change timezone
sed -i "s/'UTC'/'CST-8'\n        set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate
