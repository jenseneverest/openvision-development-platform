#!/bin/sh
echo -e ""
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
rm -f build/bitbake.lock
if grep -Fqi "ubuntu 20.04" /etc/*-release
then
    echo -e "${GREEN}You have Ubuntu 20.04.x LTS, great!${NC}"
    echo -e ""
else
    echo -e "${RED}We only support Ubuntu 20.04.x LTS!${NC}"
    echo -e ""
fi
VISIONVERSION=`cat meta-openvision/conf/distro/openvision-image.conf | grep -oP '(?<=VISIONVERSION = ")[0-9]*.[0-9]*'`
VISIONREVISION=`cat meta-openvision/conf/distro/revision.conf | grep -oP '(?<=VISIONREVISION = "r)[0-9]*'`
VISIONSTATUSCOLOR=`cat meta-openvision/conf/distro/vision-status-color`
echo -e "${BLUE}Welcome to Open Vision ${GREEN}${VISIONVERSION}-r${VISIONREVISION} ${BLUE}image compile script!"
echo -e ""
if [ "${VISIONSTATUSCOLOR}" == 'RED' ]; then
	echo -e "${RED}Code RED detected!"
	echo -e "It means you need to use cleanup.sh (Build) but only once!"
	echo -e "If you already used cleanup.sh (Build) ignore this message."
	echo -e "RED releases happen when we do OE upgrades.${NC}"
else
	echo -e "${GREEN}It's a normal release, no need to use cleanup.sh${NC}"
fi
echo -e ""
echo -e "${YELLOW}Notice: This script is case sensitive!${NC}"
echo -e ""
echo -e "First we need to check your Ubuntu 20.04.x"
echo -e ""
if [ -f user.ovstep ]; then
	echo -e "Seems you run ltsubuntu.sh before but keep in mind it's better to run it each month to get latest updates."
	echo -e ""
	if grep -Fqi "twice" user.ovstep
	then
	    echo -e "Seems you have the second updates too."
	    echo -e ""
	else
	    echo -e "We know you run ltsubuntu.sh before but there are some updates available!"
	    /bin/sh ltsubuntu.sh
	    echo "twice" >> user.ovstep
	fi
else
	echo -e "Oh, we need to setup your Ubuntu so you need internet connection and a cup of coffee."
	/bin/sh ltsubuntu.sh
	echo "once" > user.ovstep
fi
if [ $(gcc -dumpversion) != '10' ]; then
	echo -e "${RED}GCC version is wrong!"
	echo -e "It means you need to choose version 10 of GCC!"
	sudo update-alternatives --config gcc
	echo -e "Done, now GCC version is: $(gcc -dumpfullversion) ${NC}"
	echo -e ""
else
	echo -e "${GREEN}You enabled GCC 10 for OV 10.x, great!${NC}"
	echo -e ""
fi
DEVELOPERNAME=`git config user.name`
if [ "${DEVELOPERNAME}" != '' ]; then
	echo "DEVELOPER_NAME = '${DEVELOPERNAME}'" > meta-openvision/conf/distro/developer.conf
else
	echo -e "${RED}You don't have a git username!${NC}"
	echo -e ""
	echo -e "${BLUE}Enter a name as your git username:${NC}"
	echo -e "${GREEN}"
	read GITUSERNAME
	echo -e "${NC}"
	git config --global user.name "${GITUSERNAME}"
	echo "DEVELOPER_NAME = '${GITUSERNAME}'" > meta-openvision/conf/distro/developer.conf
fi
echo -e "${BLUE}Check ${NC}Vision-metas.md ${BLUE}and enter a meta or a specific machine to compile."
echo -e "Answers are in ${GREEN}green:${NC}"
echo -e ""
echo -e "${GREEN}Amiko ${NC}- ${GREEN}AX ${NC}- ${GREEN}AZBox  ${NC}- ${GREEN}Beyonwiz ${NC}- ${GREEN}BlackBox ${NC}- ${GREEN}BroadMedia ${NC}- ${GREEN}Ceryon"
echo -e "DAGS ${NC}- ${GREEN}Dinobot ${NC}- ${GREEN}Dreambox ${NC}- ${GREEN}EBox ${NC}- ${GREEN}Edision ${NC}- ${GREEN}Entwopia ${NC}- ${GREEN}Formuler"
echo -e "GFutures ${NC}- ${GREEN}GigaBlue ${NC}- ${GREEN}INI ${NC}- ${GREEN}IXUSS ${NC}- ${GREEN}MaxyTec ${NC}- ${GREEN}Octagon"
echo -e "Odin ${NC}- ${GREEN}Protek ${NC}- ${GREEN}RPi ${NC}- ${GREEN}SH4 ${NC}- ${GREEN}Tiviar ${NC}- ${GREEN}Tripledot"
echo -e "Uclan ${NC}- ${GREEN}UltraMini ${NC}- ${GREEN}VuPlus ${NC}- ${GREEN}XCore ${NC}- ${GREEN}XP"
echo -e "Xtrend ${NC}- ${GREEN}Zgemma ${NC}- ${GREEN}Specific"
echo -e ""
echo -e "${GREEN}Specific${BLUE}: You have a specific machine in mind, Check ${NC}Vision-metas.md"
echo -e ""
echo -e "${BLUE}Enter the meta name:${NC}"
echo -e "${GREEN}"
read META
echo -e "${NC}"
if [ $META != "Amiko" -a $META != "AX" -a $META != "AZBox" -a $META != "Beyonwiz" -a $META != "BlackBox" -a $META != "BroadMedia" -a $META != "Ceryon" -a $META != "DAGS" -a $META != "Dinobot" -a $META != "Dreambox" -a $META != "EBox" -a $META != "Edision" -a $META != "Entwopia" -a $META != "Formuler" -a $META != "GFutures" -a $META != "GigaBlue" -a $META != "INI" -a $META != "IXUSS" -a $META != "MaxyTec" -a $META != "Octagon" -a $META != "Odin" -a $META != "Protek" -a $META != "RPi" -a $META != "SH4" -a $META != "Tiviar" -a $META != "Tripledot" -a $META != "Uclan" -a $META != "UltraMini" -a $META != "VuPlus" -a $META != "XCore" -a $META != "XP" -a $META != "Xtrend" -a $META != "Zgemma" -a $META != "Specific" ]
then
	echo -e "${RED}Not a valid answer!${NC}"
	echo -e ""
	exit 0
fi
echo -e "${BLUE}Now choose whether you want to compile Open Vision or the online feeds."
echo -e "Answers are in ${GREEN}green:${NC}"
echo -e ""
echo -e "${GREEN}Vision ${NC}- ${GREEN}Feed ${NC}- ${GREEN}Kernel-Clean${NC}"
echo -e ""
echo -e "${BLUE}Enter image type:${NC}"
echo -e "${GREEN}"
read IMAGETYPE
echo -e "${NC}"
if [ $IMAGETYPE != "Vision" -a $IMAGETYPE != "Feed" -a $IMAGETYPE != "Kernel-Clean" ]
then
	echo -e "${RED}Not a valid answer!${NC}"
	echo -e ""
	exit 0
fi
echo -e "${BLUE}First update everything, please wait ...${NC}"
/bin/sh update.sh
sleep 0.1
#gnome-terminal --tab --title="GitHub keep alive terminal" --command="ping github.com"
echo -e ""
echo -e "${BLUE}Updated.${NC}"
echo -e ""
begin=$(date +"%s")
echo -e "${BLUE}Compiling${GREEN} $META ${BLUE}images, please wait ...${NC}"
echo -e ""
if [ $IMAGETYPE = "Vision" ]
then
	IMAGECMD='make image'
fi
if [ $IMAGETYPE = "Feed" ]
then
	IMAGECMD='make feed'
	if grep -Fqi "feed" user.ovstep
	then
	    echo -e "${BLUE}No need to set custom feed.${NC}"
	    echo -e ""
	else
	    echo -e "${BLUE}Do you want to set your own feed?"
	    echo -e ""
	    echo -e "Answers are in ${GREEN}green:${NC}"
	    echo -e ""
	    echo -e "${GREEN}Yes ${NC}- ${GREEN}No"
	    echo -e ""
	    echo -e "${BLUE}Enter custom feed mode:${NC}"
	    echo -e "${GREEN}"
	    read OWNFEED
	    echo -e "${NC}"
	    if [ $OWNFEED != "Yes" -a $OWNFEED != "No" ]
	    then
		echo -e "${RED}Not a valid answer!${NC}"
		echo -e ""
		exit 0
	    fi
	    if [ $OWNFEED = "No" ]
	    then
		echo "feed-is-not-set" >> user.ovstep
	    fi
	    if [ $OWNFEED = "Yes" ]
	    then
		echo -e "${BLUE}Enter your desired IP or URL without http or anything extra:"
		echo -e "${GREEN}"
		read USERURL
		echo -e "${NC}"
		sed -i '1 s/#//g' meta-openvision/conf/distro/openvision-testers.conf
		sed -i "s|openvisiontesters|$USERURL|g" meta-openvision/conf/distro/openvision-testers.conf
		echo "feed-is-set-to=${USERURL}" >> user.ovstep
		echo -e "${BLUE}Done!${GREEN} $USERURL ${BLUE}is now set as your custom feed.${NC}"
		echo -e ""
	    fi
	fi
fi
if [ $IMAGETYPE = "Kernel-Clean" ]
then
	IMAGECMD='make kernel-clean'
fi
if [ $META = "Specific" ]
then
	echo -e "${BLUE}Enter your specific machine name exactly like what you see in ${NC}Vision-metas.md"
	echo -e "${GREEN}"
	read MACHINESPECIFIC
	echo -e "${NC}"
	echo -e "${BLUE}Compiling${GREEN} $MACHINESPECIFIC ${BLUE}image, please wait ...${NC}"
	echo -e ""
	MACHINE=$MACHINESPECIFIC $IMAGECMD
fi
if [ $META = "Amiko" ]
then
	MACHINE=viper4k $IMAGECMD
	MACHINE=vipercombo $IMAGECMD
	MACHINE=vipercombohdd $IMAGECMD
	MACHINE=viperslim $IMAGECMD
	MACHINE=vipert2c $IMAGECMD
fi
if [ $META = "AX" ]
then
	MACHINE=triplex $IMAGECMD
	MACHINE=ultrabox $IMAGECMD
fi
if [ $META = "AZBox" ]
then
	MACHINE=azboxme $IMAGECMD
	MACHINE=azboxminime $IMAGECMD
fi
if [ $META = "Beyonwiz" ]
then
	MACHINE=beyonwizv2 $IMAGECMD
fi
if [ $META = "BlackBox" ]
then
	MACHINE=sogno8800hd $IMAGECMD
	MACHINE=uniboxhde $IMAGECMD
fi
if [ $META = "BroadMedia" ]
then
	MACHINE=alphatriplehd $IMAGECMD
	MACHINE=bre2zet2c $IMAGECMD
	MACHINE=mbtwinplus $IMAGECMD
	MACHINE=sf128 $IMAGECMD
	MACHINE=sf138 $IMAGECMD
	MACHINE=sf3038 $IMAGECMD
fi
if [ $META = "Ceryon" ]
then
	MACHINE=9910lx $IMAGECMD
	MACHINE=9911lx $IMAGECMD
	MACHINE=9920lx $IMAGECMD
	MACHINE=e4hd $IMAGECMD
	MACHINE=e4hdcombo $IMAGECMD
	MACHINE=e4hdhybrid $IMAGECMD
	MACHINE=e4hdultra $IMAGECMD
	MACHINE=mbmicro $IMAGECMD
	MACHINE=mbmicrov2 $IMAGECMD
	MACHINE=odin2hybrid $IMAGECMD
	MACHINE=odinplus $IMAGECMD
	MACHINE=protek4k $IMAGECMD
	MACHINE=sf208 $IMAGECMD
	MACHINE=sf228 $IMAGECMD
	MACHINE=sf238 $IMAGECMD
	MACHINE=singleboxlcd $IMAGECMD
	MACHINE=twinboxlcd $IMAGECMD
	MACHINE=twinboxlcdci5 $IMAGECMD
fi
if [ $META = "DAGS" ]
then
	MACHINE=force1 $IMAGECMD
	MACHINE=force1plus $IMAGECMD
	MACHINE=force2 $IMAGECMD
	MACHINE=force2nano $IMAGECMD
	MACHINE=force2plus $IMAGECMD
	MACHINE=force2plushv $IMAGECMD
	MACHINE=force2se $IMAGECMD
	MACHINE=force3uhd $IMAGECMD
	MACHINE=force3uhdplus $IMAGECMD
	MACHINE=force4 $IMAGECMD
	MACHINE=fusionhd $IMAGECMD
	MACHINE=fusionhdse $IMAGECMD
	MACHINE=galaxy4k $IMAGECMD
	MACHINE=iqonios100hd $IMAGECMD
	MACHINE=iqonios200hd $IMAGECMD
	MACHINE=iqonios300hd $IMAGECMD
	MACHINE=iqonios300hdv2 $IMAGECMD
	MACHINE=lunix $IMAGECMD
	MACHINE=lunix34k $IMAGECMD
	MACHINE=lunix4k $IMAGECMD
	MACHINE=lunixco $IMAGECMD
	MACHINE=mediabox $IMAGECMD
	MACHINE=optimussos $IMAGECMD
	MACHINE=optimussos1 $IMAGECMD
	MACHINE=optimussos1plus $IMAGECMD
	MACHINE=optimussos2 $IMAGECMD
	MACHINE=optimussos2plus $IMAGECMD
	MACHINE=optimussos3plus $IMAGECMD
	MACHINE=purehd $IMAGECMD
	MACHINE=purehdse $IMAGECMD
	MACHINE=revo4k $IMAGECMD
	MACHINE=tm2t $IMAGECMD
	MACHINE=tm4ksuper $IMAGECMD
	MACHINE=tmnano $IMAGECMD
	MACHINE=tmnano2super $IMAGECMD
	MACHINE=tmnano2t $IMAGECMD
	MACHINE=tmnano3t $IMAGECMD
	MACHINE=tmnanom3 $IMAGECMD
	MACHINE=tmnanose $IMAGECMD
	MACHINE=tmnanosecombo $IMAGECMD
	MACHINE=tmnanosem2 $IMAGECMD
	MACHINE=tmnanoseplus $IMAGECMD
	MACHINE=tmsingle $IMAGECMD
	MACHINE=tmtwin $IMAGECMD
	MACHINE=tmtwin4k $IMAGECMD
	MACHINE=valalinux $IMAGECMD
	MACHINE=worldvisionf1 $IMAGECMD
	MACHINE=worldvisionf1plus $IMAGECMD
fi
if [ $META = "Dinobot" ]
then
	MACHINE=anadol4k $IMAGECMD
	MACHINE=anadol4kv2 $IMAGECMD
	MACHINE=anadolprohd5 $IMAGECMD
	MACHINE=arivacombo $IMAGECMD
	MACHINE=arivatwin $IMAGECMD
	MACHINE=axashis4kcombo $IMAGECMD
	MACHINE=axashis4kcomboplus $IMAGECMD
	MACHINE=axashisc4k $IMAGECMD
	MACHINE=axashistwin $IMAGECMD
	MACHINE=dinobot4k $IMAGECMD
	MACHINE=dinobot4kl $IMAGECMD
	MACHINE=dinobot4kmini $IMAGECMD
	MACHINE=dinobot4kplus $IMAGECMD
	MACHINE=dinobot4kpro $IMAGECMD
	MACHINE=dinobot4kse $IMAGECMD
	MACHINE=dinoboth265 $IMAGECMD
	MACHINE=dinobotu43 $IMAGECMD
	MACHINE=dinobotu55 $IMAGECMD
	MACHINE=iziboxelite4k $IMAGECMD
	MACHINE=iziboxx3 $IMAGECMD
	MACHINE=protek4kx1 $IMAGECMD
	MACHINE=turing $IMAGECMD
	MACHINE=viper4kv20 $IMAGECMD
	MACHINE=vipersingle $IMAGECMD
fi
if [ $META = "Dreambox" ]
then
	MACHINE=dm500hdv2 $IMAGECMD
	MACHINE=dm520 $IMAGECMD
	MACHINE=dm7020hd $IMAGECMD
	MACHINE=dm7020hdv2 $IMAGECMD
	MACHINE=dm7080 $IMAGECMD
	MACHINE=dm8000 $IMAGECMD
	MACHINE=dm800sev2 $IMAGECMD
	MACHINE=dm820 $IMAGECMD
	MACHINE=dm900 $IMAGECMD
	MACHINE=dm920 $IMAGECMD
fi
if [ $META = "EBox" ]
then
	MACHINE=ebox5000 $IMAGECMD
	MACHINE=ebox5100 $IMAGECMD
	MACHINE=ebox7358 $IMAGECMD
	MACHINE=eboxlumi $IMAGECMD
fi
if [ $META = "Edision" ]
then
	MACHINE=osmega $IMAGECMD
	MACHINE=osmini $IMAGECMD
	MACHINE=osmini4k $IMAGECMD
	MACHINE=osminiplus $IMAGECMD
	MACHINE=osmio4k $IMAGECMD
	MACHINE=osmio4kplus $IMAGECMD
	MACHINE=osnino $IMAGECMD
	MACHINE=osninoplus $IMAGECMD
	MACHINE=osninopro $IMAGECMD
fi
if [ $META = "Entwopia" ]
then
	MACHINE=bre2ze $IMAGECMD
	MACHINE=enfinity $IMAGECMD
	MACHINE=evomini $IMAGECMD
	MACHINE=evominiplus $IMAGECMD
	MACHINE=marvel1 $IMAGECMD
	MACHINE=x2plus $IMAGECMD
fi
if [ $META = "Formuler" ]
then
	MACHINE=formuler1 $IMAGECMD
	MACHINE=formuler3 $IMAGECMD
	MACHINE=formuler4 $IMAGECMD
	MACHINE=formuler4turbo $IMAGECMD
fi
if [ $META = "GFutures" ]
then
	MACHINE=axultra $IMAGECMD
	MACHINE=bre2ze4k $IMAGECMD
	MACHINE=hd11 $IMAGECMD
	MACHINE=hd1100 $IMAGECMD
	MACHINE=hd1200 $IMAGECMD
	MACHINE=hd1265 $IMAGECMD
	MACHINE=hd1500 $IMAGECMD
	MACHINE=hd2400 $IMAGECMD
	MACHINE=hd500c $IMAGECMD
	MACHINE=hd51 $IMAGECMD
	MACHINE=hd530c $IMAGECMD
	MACHINE=hd60 $IMAGECMD
	MACHINE=hd61 $IMAGECMD
	MACHINE=vs1000 $IMAGECMD
	MACHINE=vs1500 $IMAGECMD
fi
if [ $META = "GigaBlue" ]
then
	MACHINE=gb800seplus $IMAGECMD
	MACHINE=gb800solo $IMAGECMD
	MACHINE=gb800ueplus $IMAGECMD
	MACHINE=gbip4k $IMAGECMD
	MACHINE=gbipbox $IMAGECMD
	MACHINE=gbquad $IMAGECMD
	MACHINE=gbquad4k $IMAGECMD
	MACHINE=gbquadplus $IMAGECMD
	MACHINE=gbtrio4k $IMAGECMD
	MACHINE=gbue4k $IMAGECMD
	MACHINE=gbultrase $IMAGECMD
	MACHINE=gbultraue $IMAGECMD
	MACHINE=gbultraueh $IMAGECMD
	MACHINE=gbx1 $IMAGECMD
	MACHINE=gbx2 $IMAGECMD
	MACHINE=gbx3 $IMAGECMD
	MACHINE=gbx34k $IMAGECMD
	MACHINE=gbx3h $IMAGECMD
fi
if [ $META = "INI" ]
then
	MACHINE=atemio5x00 $IMAGECMD
	MACHINE=atemio6000 $IMAGECMD
	MACHINE=atemio6100 $IMAGECMD
	MACHINE=atemio6200 $IMAGECMD
	MACHINE=atemionemesis $IMAGECMD
	MACHINE=beyonwizt2 $IMAGECMD
	MACHINE=beyonwizt3 $IMAGECMD
	MACHINE=beyonwizt4 $IMAGECMD
	MACHINE=bwidowx $IMAGECMD
	MACHINE=bwidowx2 $IMAGECMD
	MACHINE=evoslim $IMAGECMD
	MACHINE=mbhybrid $IMAGECMD
	MACHINE=mbmini $IMAGECMD
	MACHINE=mbminiplus $IMAGECMD
	MACHINE=mbtwin $IMAGECMD
	MACHINE=mbultra $IMAGECMD
	MACHINE=opticumtt $IMAGECMD
	MACHINE=sezam1000hd $IMAGECMD
	MACHINE=sezam5000hd $IMAGECMD
	MACHINE=sezammarvel $IMAGECMD
	MACHINE=ventonhdx $IMAGECMD
	MACHINE=xpeedlx $IMAGECMD
	MACHINE=xpeedlx3 $IMAGECMD
fi
if [ $META = "IXUSS" ]
then
	MACHINE=ixussone $IMAGECMD
	MACHINE=ixusszero $IMAGECMD
fi
if [ $META = "MaxyTec" ]
then
	MACHINE=multibox $IMAGECMD
	MACHINE=multiboxse $IMAGECMD
fi
if [ $META = "Octagon" ]
then
	MACHINE=sf4008 $IMAGECMD
	MACHINE=sf5008 $IMAGECMD
	MACHINE=sf8008 $IMAGECMD
	MACHINE=sf8008m $IMAGECMD
fi
if [ $META = "Odin" ]
then
	MACHINE=axase3 $IMAGECMD
	MACHINE=axodin $IMAGECMD
	MACHINE=maram9 $IMAGECMD
fi
if [ $META = "Protek" ]
then
	MACHINE=9900lx $IMAGECMD
fi
if [ $META = "RPi" ]
then
	MACHINE=raspberrypi $IMAGECMD
	MACHINE=raspberrypi0 $IMAGECMD
	MACHINE=raspberrypi2 $IMAGECMD
	MACHINE=raspberrypi3 $IMAGECMD
	MACHINE=raspberrypi4 $IMAGECMD
fi
if [ $META = "SH4" ]
then
	MACHINE=adb_box $IMAGECMD
	MACHINE=adb_2850 $IMAGECMD
	MACHINE=arivalink200 $IMAGECMD
	MACHINE=atemio520 $IMAGECMD
	MACHINE=atemio530 $IMAGECMD
	MACHINE=atevio7500 $IMAGECMD
	MACHINE=cuberevo $IMAGECMD
	MACHINE=cuberevo_2000hd $IMAGECMD
	MACHINE=cuberevo_250hd $IMAGECMD
	MACHINE=cuberevo_3000hd $IMAGECMD
	MACHINE=cuberevo_9500hd $IMAGECMD
	MACHINE=cuberevo_mini $IMAGECMD
	MACHINE=cuberevo_mini2 $IMAGECMD
	MACHINE=forever_2424hd $IMAGECMD
	MACHINE=forever_3434hd $IMAGECMD
	MACHINE=forever_9898hd $IMAGECMD
	MACHINE=forever_nanosmart $IMAGECMD
	MACHINE=fortis_hdbox $IMAGECMD
	MACHINE=hl101 $IMAGECMD
	MACHINE=hs7110 $IMAGECMD
	MACHINE=hs7119 $IMAGECMD
	MACHINE=hs7420 $IMAGECMD
	MACHINE=hs7429 $IMAGECMD
	MACHINE=hs7810a $IMAGECMD
	MACHINE=hs7819 $IMAGECMD
	MACHINE=ipbox55 $IMAGECMD
	MACHINE=ipbox99 $IMAGECMD
	MACHINE=ipbox9900 $IMAGECMD
	MACHINE=octagon1008 $IMAGECMD
	MACHINE=opt9600 $IMAGECMD
	MACHINE=pace7241 $IMAGECMD
	MACHINE=qboxhd $IMAGECMD
	MACHINE=qboxhd_mini $IMAGECMD
	MACHINE=sagemcom88 $IMAGECMD
	MACHINE=spark $IMAGECMD
	MACHINE=spark7162 $IMAGECMD
	MACHINE=tf7700 $IMAGECMD
	MACHINE=ufc960 $IMAGECMD
	MACHINE=ufs910 $IMAGECMD
	MACHINE=ufs912 $IMAGECMD
	MACHINE=ufs913 $IMAGECMD
	MACHINE=ufs922 $IMAGECMD
	MACHINE=vip1_v1 $IMAGECMD
	MACHINE=vip1_v2 $IMAGECMD
	MACHINE=vip2 $IMAGECMD
	MACHINE=vitamin_hd5000 $IMAGECMD
fi
if [ $META = "Tiviar" ]
then
	MACHINE=tiviaraplus $IMAGECMD
	MACHINE=tiviarmin $IMAGECMD
fi
if [ $META = "Tripledot" ]
then
	MACHINE=enibox $IMAGECMD
	MACHINE=evoslimse $IMAGECMD
	MACHINE=evoslimt2c $IMAGECMD
	MACHINE=mago $IMAGECMD
	MACHINE=sf108 $IMAGECMD
	MACHINE=sf98 $IMAGECMD
	MACHINE=t2cable $IMAGECMD
	MACHINE=tyrant $IMAGECMD
	MACHINE=x1plus $IMAGECMD
	MACHINE=xcombo $IMAGECMD
fi
if [ $META = "Uclan" ]
then
	MACHINE=ustym4kpro $IMAGECMD
fi
if [ $META = "UltraMini" ]
then
	MACHINE=et7000mini $IMAGECMD
	MACHINE=xpeedc $IMAGECMD
fi
if [ $META = "VuPlus" ]
then
	MACHINE=vuduo $IMAGECMD
	MACHINE=vuduo2 $IMAGECMD
	MACHINE=vuduo4k $IMAGECMD
	MACHINE=vuduo4kse $IMAGECMD
	MACHINE=vusolo $IMAGECMD
	MACHINE=vusolo2 $IMAGECMD
	MACHINE=vusolo4k $IMAGECMD
	MACHINE=vusolose $IMAGECMD
	MACHINE=vuultimo $IMAGECMD
	MACHINE=vuultimo4k $IMAGECMD
	MACHINE=vuuno $IMAGECMD
	MACHINE=vuuno4k $IMAGECMD
	MACHINE=vuuno4kse $IMAGECMD
	MACHINE=vuzero $IMAGECMD
	MACHINE=vuzero4k $IMAGECMD
fi
if [ $META = "XCore" ]
then
	MACHINE=spycat $IMAGECMD
	MACHINE=spycat4k $IMAGECMD
	MACHINE=spycat4kcombo $IMAGECMD
	MACHINE=spycat4kmini $IMAGECMD
	MACHINE=spycatmini $IMAGECMD
	MACHINE=spycatminiplus $IMAGECMD
fi
if [ $META = "XP" ]
then
	MACHINE=xp1000 $IMAGECMD
fi
if [ $META = "Xtrend" ]
then
	MACHINE=beyonwizu4 $IMAGECMD
	MACHINE=et10000 $IMAGECMD
	MACHINE=et13000 $IMAGECMD
	MACHINE=et1x000 $IMAGECMD
	MACHINE=et4x00 $IMAGECMD
	MACHINE=et5x00 $IMAGECMD
	MACHINE=et6x00 $IMAGECMD
	MACHINE=et7x00 $IMAGECMD
	MACHINE=et8000 $IMAGECMD
	MACHINE=et8500 $IMAGECMD
	MACHINE=et9x00 $IMAGECMD
fi
if [ $META = "Zgemma" ]
then
	MACHINE=h0 $IMAGECMD
	MACHINE=h10 $IMAGECMD
	MACHINE=h3 $IMAGECMD
	MACHINE=h4 $IMAGECMD
	MACHINE=h5 $IMAGECMD
	MACHINE=h6 $IMAGECMD
	MACHINE=h7 $IMAGECMD
	MACHINE=h8 $IMAGECMD
	MACHINE=h9 $IMAGECMD
	MACHINE=h9combo $IMAGECMD
	MACHINE=h9combose $IMAGECMD
	MACHINE=h9se $IMAGECMD
	MACHINE=i55 $IMAGECMD
	MACHINE=i55plus $IMAGECMD
	MACHINE=i55plusse $IMAGECMD
	MACHINE=lc $IMAGECMD
	MACHINE=novacombo $IMAGECMD
	MACHINE=novaip $IMAGECMD
	MACHINE=novatwin $IMAGECMD
	MACHINE=sh1 $IMAGECMD
fi
echo -e ""
echo -e "${BLUE}Done, the compiled image is in ${NC}build/tmp/deploy/images/${GREEN}$MACHINE$MACHINESPECIFIC ${BLUE}folder!"
echo -e "It's a zipped file like ${NC}openvision-enigma2-extralanguage-${GREEN}${VISIONVERSION}-r${VISIONREVISION}${NC}-${RED}$MACHINE$MACHINESPECIFIC${NC}.zip"
echo -e ""
finish=$(date +"%s")
timediff=$(($finish-$begin))
echo -e "Compile time was $(($timediff / 60)) minutes and $(($timediff % 60)) seconds."
echo -e "Fast compiling would be less than 60 minutes."
