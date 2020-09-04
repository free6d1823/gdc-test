CONFIG_MODULE_SIG=n


#redefine ARCH
ifeq ($(ARCH),)    
    $(error "please set ARCH!")
else
    _ARCH=${ARCH}
endif


#redefine CROSS_COMPILE
ifeq ($(CROSS_COMPILE),)    
    $(error "please set CROSS_COMPILE prefix!")
else
    _CROSS_COMPILE=${CROSS_COMPILE}
endif

#redefine KDIR
ifeq ($(KDIR),)    
    $(error "please set KDIR for kernel directory!")
else
    _KDIR=${KDIR}
endif



obj-m += gdc.o

ifeq ($(FW_SRC_OBJ),)
	FW_SRC := $(wildcard src/*.c src/*/*.c src/*/*/*.c app/*.c app/*/*.c ../bsp/*.c)
	export FW_SRC_OBJ := $(FW_SRC:.c=.o)
endif


gdc-objs += $(FW_SRC_OBJ) 

INCLUDE_DIRS := $(addprefix -I,$(shell find ../ -type d ))

ccflags-y:=-I$(PWD)/app -I$(PWD)/inc -I$(PWD)/app/control -I$(PWD)/inc/api -I$(PWD)/inc/gdc -I$(PWD)/inc/sys -I$(PWD)/src/platform -I$(PWD)/src/fw  -I$(PWD)/src/fw_lib  -I$(PWD)/src/driver/lens -I$(_KDIR)/include/linux/

ccflags-y += -Wno-declaration-after-statement

all:
		CROSS_COMPILE=${_CROSS_COMPILE} make ARCH=${_ARCH} -C $(_KDIR) M=$(PWD) modules

clean:
		CROSS_COMPILE=${_CROSS_COMPILE} make ARCH=${_ARCH} -C $(_KDIR) M=$(PWD) clean

