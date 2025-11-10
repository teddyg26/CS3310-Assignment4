# TODO: Setup auto object file generation and dependencies,
#       so that only modified files are recompiled.

# Determine OS and set compiler accordingly
OS_NAME := $(shell uname -s)

ifeq ($(OS_NAME),Linux)
# Variables specific to Linux
	CC = g++
	CFLAGS = --std=c++17 -Wall -g
	LIBS = -lm
else ifeq ($(OS_NAME),Darwin) # macOS
# Variables specific to macOS
	CC = clang++
	CFLAGS = --std=c++17 -Wall -g
	LIBS = -framework CoreFoundation
else ifeq ($(OS_NAME),Windows_NT) # Windows (using MinGW or Cygwin)
# Variables specific to Windows
	CC = g++
	CFLAGS = --std=c++17 -Wall
	LIBS = -lws2_32
else
# Default or fallback variables
	CC = gcc
	CFLAGS = --std=c++17 -Wall
	LIBS =
endif

OBJ = search.o parser.o linkedlist.o

all: search parser linkedlist

search: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

parser: parser.o linkedlist.o
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

linkedlist: linkedlist.o
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

# Note: 'leaks' is a macOS-specific tool. 
# This will need to be adjusted for other OSes.
memcheck:
	@if [ -z "$(PROG)" ]; then \
		echo "Usage: make memcheck PROG=parser|search"; exit 1; \
	fi
	leaks --atExit -- $(PROG)

memsearch: search
	$(MAKE) memcheck PROG=search

memparser: parser
	$(MAKE) memcheck PROG=parser

memlinkedlist: linkedlist
	$(MAKE) memcheck PROG=linkedlist

.PHONY: clean
clean:
	rm -f *.o search parser linkedlist