CC=g++
RM=rm
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

all: dirs posttotwitter twitposter genconf

dirs:
	mkdir -p bin /var/run/twitposter/
	chmod 755 bin /var/run/twitposter/

posttotwitter: $(OBJS)
	$(CC) $(CPPFLAGS) $(OBJS) -o posttotwitter $(LDFLAGS)
	mv posttotwitter bin

# Generates a SysVinit service file.
twitposter:
	cp templates/twitposter.service.template bin/twitposter.service
	printf "\n$(shell pwd)/bash/main.sh \"%s@\"\n" '$$' >> bin/twitposter.service
	chmod 755 bin/twitposter.service

genconf:
	printf "PARENT_DIR=\"$(shell pwd)\"\n" > twitposter.conf
	cat templates/twitposter.conf.template >> twitposter.conf

clean:
	$(RM) -f $(OBJS) twitposter.conf /var/log/twitposter.log
	$(RM) -rf bin /var/run/twitposter/;
