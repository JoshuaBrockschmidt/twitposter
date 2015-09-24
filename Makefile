NAME=posttotwitter
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

all: $(NAME) genConf dirs

$(NAME): $(OBJS)
	$(CC) $(CPPFLAGS) $(OBJS) -o $(NAME) $(LDFLAGS)
	mv $(NAME) bin

genConf:
	printf "\
PARENT_DIR  = \"$(shell pwd)/\n\
STATUS_FILE = \"$(shell pwd)/var/status\"\n\
LOG_FILE    = \"$(shell pwd)/var/twitposter.log\"\n\
ELAPSE_MIN  = 30\n\
ELAPSE_MAX  = 240\n\
TWEET_CMD   = \"echo This tweet was posted via TwitPoster (http://github.com/JoshuaBrockschmidt/twitposter/)\"\n\
TRY_LIMIT   = 10\n" > $(CONFIG_FILE)

dirs:
	mkdir -p var;
	chmod 766 var

clean:
	$(RM) -f bin/$(NAME) $(OBJS) $(CONFIG_FILE)
	$(RM) -rf var;
