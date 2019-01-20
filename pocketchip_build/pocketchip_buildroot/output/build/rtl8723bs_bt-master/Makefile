rtk_hciattach:hciattach.c hciattach_rtk.o  
	cc -o rtk_hciattach hciattach.c hciattach_rtk.o  

hciattach_rtk.o:hciattach_rtk.c
	cc -c hciattach_rtk.c

clean:
	rm -f *.o  rtk_hciattach

install:
#	mkdir -p /lib/firmware/rtl_bt
#	cp -p rtlbt_* /lib/firmware/rtl_bt/.
#
# hjkim: 2018.03.20
	mkdir -p ../../target/lib/firmware/rtl_bt
	cp -p rtlbt_* ../../target/lib/firmware/rtl_bt/.
