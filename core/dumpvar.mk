# ---------------------------------------------------------------
# the setpath shell function in envsetup.sh uses this to figure out
# what to add to the path given the config we have chosen.
ifeq ($(CALLED_FROM_SETUP),true)

ifneq ($(filter /%,$(HOST_OUT_EXECUTABLES)),)
ABP:=$(HOST_OUT_EXECUTABLES)
else
ABP:=$(PWD)/$(HOST_OUT_EXECUTABLES)
endif

ANDROID_BUILD_PATHS := $(ABP)
ANDROID_PREBUILTS := prebuilt/$(HOST_PREBUILT_TAG)
ANDROID_GCC_PREBUILTS := prebuilts/gcc/$(HOST_PREBUILT_TAG)

# The "dumpvar" stuff lets you say something like
#
#     CALLED_FROM_SETUP=true \
#       make -f config/envsetup.make dumpvar-TARGET_OUT
# or
#     CALLED_FROM_SETUP=true \
#       make -f config/envsetup.make dumpvar-abs-HOST_OUT_EXECUTABLES
#
# The plain (non-abs) version just dumps the value of the named variable.
# The "abs" version will treat the variable as a path, and dumps an
# absolute path to it.
#
dumpvar_goals := \
	$(strip $(patsubst dumpvar-%,%,$(filter dumpvar-%,$(MAKECMDGOALS))))
ifdef dumpvar_goals

  ifneq ($(words $(dumpvar_goals)),1)
    $(error Only one "dumpvar-" goal allowed. Saw "$(MAKECMDGOALS)")
  endif

  # If the goal is of the form "dumpvar-abs-VARNAME", then
  # treat VARNAME as a path and return the absolute path to it.
  absolute_dumpvar := $(strip $(filter abs-%,$(dumpvar_goals)))
  ifdef absolute_dumpvar
    dumpvar_goals := $(patsubst abs-%,%,$(dumpvar_goals))
    ifneq ($(filter /%,$($(dumpvar_goals))),)
      DUMPVAR_VALUE := $($(dumpvar_goals))
    else
      DUMPVAR_VALUE := $(PWD)/$($(dumpvar_goals))
    endif
    dumpvar_target := dumpvar-abs-$(dumpvar_goals)
  else
    DUMPVAR_VALUE := $($(dumpvar_goals))
    dumpvar_target := dumpvar-$(dumpvar_goals)
  endif

.PHONY: $(dumpvar_target)
$(dumpvar_target):
	@echo $(DUMPVAR_VALUE)

endif # dumpvar_goals

ifneq ($(dumpvar_goals),report_config)
PRINT_BUILD_CONFIG:=
endif

endif # CALLED_FROM_SETUP

ifneq ($(BUILD_WITH_COLORS),0)
    include $(TOP_DIR)build/core/colors.mk
endif


ifneq ($(PRINT_BUILD_CONFIG),)
HOST_OS_EXTRA:=$(shell python -c "import platform; print(platform.platform())")
$(info ${CLR_CYN} ============================================)
$(info ${CLR_YLW}   PLATFORM_VERSION_CODENAME=$(PLATFORM_VERSION_CODENAME))
$(info ${CLR_YLW}   PLATFORM_VERSION=$(PLATFORM_VERSION))
$(info ${CLR_CYN} ==================TipsyOs===================)
$(info ${CLR_CYN} ============================================)
$(info $(CLR_BOLD)${CLR_GRN}   TIPSY_VERSION=$(TIPSY_VERSION)$(CLR_RST))
$(info ${CLR_CYN} ============================================)
$(info ${CLR_YLW}   TARGET_PRODUCT=$(TARGET_PRODUCT))
$(info ${CLR_YLW}   TARGET_BUILD_VARIANT=$(TARGET_BUILD_VARIANT))
$(info ${CLR_YLW}   TARGET_BUILD_TYPE=$(TARGET_BUILD_TYPE))
$(info ${CLR_YLW}   TARGET_ARCH=$(TARGET_ARCH))
$(info ${CLR_YLW}   TARGET_ARCH_VARIANT=$(TARGET_ARCH_VARIANT))
$(info ${CLR_YLW}   TARGET_CPU_VARIANT=$(TARGET_CPU_VARIANT))
$(info ${CLR_YLW}   TARGET_2ND_ARCH=$(TARGET_2ND_ARCH))
$(info ${CLR_YLW}   TARGET_2ND_ARCH_VARIANT=$(TARGET_2ND_ARCH_VARIANT))
$(info ${CLR_YLW}   TARGET_2ND_CPU_VARIANT=$(TARGET_2ND_CPU_VARIANT))
$(info ${CLR_MAG}   ROM_TOOLCHAIN_USED=$(TARGET_GCC_VERSION))
ifdef TARGET_GCC_VERSION_ARM
$(info ${CLR_MAG}   TARGET_NDK_GCC_VERSION=$(TARGET_NDK_GCC_VERSION))
ifdef TARGET_GCC_VERSION_ARM
endif
$(info ${CLR_MAG}   TARGET_KERNEL_TOOLCHAIN=$(TARGET_GCC_VERSION_ARM))
else
$(info ${CLR_MAG}   TARGET_KERNEL_TOOLCHAIN=6.x-uber)
endif
$(info ${CLR_CYN} ============================================)
ifdef CLANG_O3
$(info ${CLR_MAG}   CLANG_O3=$(CLANG_O3))
else
$(info ${CLR_MAG}   CLANG_O3=true)
endif
ifdef CORTEX_TUNINGS
$(info ${CLR_MAG}   CORTEX_TUNINGS=$(CORTEX_TUNINGS))
else
$(info ${CLR_MAG}   CORTEX_TUNINGS=true)
endif
ifdef ENABLE_GCCONLY
$(info ${CLR_MAG}   ENABLE_GCCONLY=$(ENABLE_GCCONLY))
else
$(info ${CLR_MAG}   ENABLE_GCCONLY=true)
endif
ifdef ENABLE_SANITIZE
$(info ${CLR_MAG}   ENABLE_SANITIZE=$(ENABLE_SANITIZE))
else
$(info ${CLR_MAG}   ENABLE_SANITIZE=true)
endif
ifdef GRAPHITE_OPTS
$(info ${CLR_MAG}   GRAPHITE_OPTS=$(GRAPHITE_OPTS))
else
$(info ${CLR_MAG}   GRAPHITE_OPTS=true)
endif
ifdef KRAIT_TUNINGS
$(info ${CLR_MAG}   KRAIT_TUNINGS=$(KRAIT_TUNINGS))
else
$(info ${CLR_MAG}   KRAIT_TUNINGS=false)
endif
ifdef STRICT_ALIASING
$(info ${CLR_MAG}   STRICT_ALIASING=$(STRICT_ALIASING))
else
$(info ${CLR_MAG}   STRICT_ALIASING=true)
endif
ifdef USE_PIPE
$(info ${CLR_MAG}   USE_PIPE=$(USE_PIPE))
else
$(info ${CLR_MAG}   USE_PIPE=true)
endif
ifdef POLLY_OPTIMIZATION
$(info ${CLR_MAG}   POLLY_OPTIMIZATION=$(POLLY_OPTIMIZATION))
else
$(info ${CLR_MAG}   POLLY_OPTIMIZATION=true)
endif
$(info ${CLR_CYN} ============================================)
$(info ${CLR_YLW}   HOST_ARCH=$(HOST_ARCH))
$(info ${CLR_YLW}   HOST_OS=$(HOST_OS))
$(info ${CLR_YLW}   HOST_OS_EXTRA=$(HOST_OS_EXTRA))
$(info ${CLR_YLW}   HOST_BUILD_TYPE=$(HOST_BUILD_TYPE))
$(info ${CLR_YLW}   BUILD_ID=$(BUILD_ID))
$(info ${CLR_YLW}   OUT_DIR=$(OUT_DIR))
$(info ${CLR_CYN} ============================================)
endif
