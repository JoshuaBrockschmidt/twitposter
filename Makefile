NAME1=posttotwitter
NAME2=twitposter
CC=g++
RM=rm
CONFIG_FILE=twitposter.conf
SOURCES   := $(wildcard src/*.cpp)
OBJS      := $(SOURCES:.cpp=.o)
INCLUDES  := -Iinclude
WARNFLAGS := -Wall -Wextra -Wshadow -Wcast-align -Wwrite-strings -Winline
WARNFLAGS += -Wno-attributes -Wno-deprecated-declarations
WARNFLAGS += -Wno-div-by-zero -Wno-endif-labels -Wfloat-equal
WARNFLAGS += -Wformat=2 -Wno-format-extra-args -Winit-self
WARNFLAGS += -Winvalid-pch -Wmissing-format-attribute
WARNFLAGS += -Wmissing-include-dirs -Wno-multichar -Wshadow
WARNFLAGS += -Wno-sign-compare -Wswitch
WARNFLAGS += -Wno-pragmas -Wno-unused-but-set-parameter
WARNFLAGS += -Wno-unused-but-set-variable -Wno-unused-result
WARNFLAGS += -Wwrite-strings -Wdisabled-optimization -Wpointer-arith
CPPFLAGS  := $(INCLUDES) $(WARNFLAGS) -std=c++11
LDFLAGS   := -L. -ltwitcurl

all: dirs $(NAME1) $(NAME2) genConf

dirs:
	mkdir -p bin var
	chmod 755 bin
	chmod 766 var

$(NAME1): $(OBJS)
	$(CC) $(CPPFLAGS) $(OBJS) -o $(NAME1) $(LDFLAGS)
	mv $(NAME1) bin

$(NAME2):
	printf "#!/usr/bin/env bash\n\n\
$(shell pwd)/bash/main.sh \"%s@\"\n" '$$' > bin/$(NAME2)
#TODO: print $@ literally
	chmod 755 bin/$(NAME2)

genConf:
	printf "\
PARENT_DIR=\"$(shell pwd)\"/\n\
STATUS_FILE=\"$(shell pwd)/var/status\"\n\
LOG_FILE=\"$(shell pwd)/var/twitposter.log\"\n\
ELAPSE_MIN=30\n\
ELAPSE_MAX=240\n\
TWEET_CMD=\"echo This tweet was posted via TwitPoster (http://github.com/JoshuaBrockschmidt/twitposter/)\"\n\
TRY_LIMIT=10\n" > $(CONFIG_FILE)

clean:
	$(RM) -f $(OBJS) $(CONFIG_FILE)
	$(RM) -rf var bin;
