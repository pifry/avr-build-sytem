CC = docker run \
		--rm \
		--mount src=$(PWD),target=/home/src,type=bind \
		cpputest g++

CC_AVR=docker run \
		--rm \
		--mount src=$(PWD),target=/home,type=bind \
		avr-test avr-gcc

SRC_FILES=src/main.c \
		src/hal.c

CFLAGS_AVR += -I include/ \
		-O1

# CPPUTEST cpecyfic flags
CPPUTEST_HOME=/home/cpputest
CPPFLAGS += -I$(CPPUTEST_HOME)/include
CXXFLAGS += -include $(CPPUTEST_HOME)/include/CppUTest/MemoryLeakDetectorNewMacros.h
CFLAGS += -include $(CPPUTEST_HOME)/include/CppUTest/MemoryLeakDetectorMallocMacros.h
LD_LIBRARIES = /home/cpputest/lib/libCppUTest.a /home/cpputest/lib/libCppUTestExt.a



DEVICE=atmega8

all: bin/avr/main

# ###### Docker specyfic targets #####

build_container_avr:
	docker build -t avr-test -f Dockerfiles/Dockerfile.avr .

build_container_cpputest:
	docker build -t cpputest -f Dockerfiles/Dockerfile.cpputest .

build_containers: build_container_avr

interactive_avr:
	docker run \
		-i \
		--rm \
		--mount src=$(PWD),target=/home,type=bind \
		avr-test bash

interactive_cpputest:
	docker run \
		-i \
		--rm \
		--mount src=$(PWD),target=/home/src,type=bind \
		cpputest bash

test:
	docker run \
		--rm \
		--mount src=$(PWD),target=/home,type=bind \
		avr-test gcc

# ###### AVR specyfic targets #####

bin/avr/main: $(SRC_FILES)
	mkdir -p bin/avr
	$(CC_AVR) $(CFLAGS_AVR) -mmcu=$(DEVICE) -o $@ $?

# ###### CppUTest specyfic targets #####

obj/tests/%.o: tests/%.cpp
	mkdir -p obj/tests
	$(CC) $(CFLAGS) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $?

bin/tests/%: obj/tests/allTests.o obj/tests/simple.o
	mkdir -p bin/tests
	$(CC) -o $@ $? $(LD_LIBRARIES)
	

test: bin/tests/allTests
	./bin/tests/allTests

clean:
	rm -rf bin obj

.PHONY: clean build_containers build_container_avr interactive test all