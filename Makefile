CC=docker run \
		--rm \
		--mount src=$(PWD),target=/home,type=bind \
		avr-test avr-gcc

SRC_FILES=src/main.c \
		src/hal.c

INCLUDE=include/

DEVICE=atmega8

all: bin/main

build_container_avr:
	docker build -t avrtest -f Dockerfiles/Dockerfile.avr .

build_containers: build_container_avr

interactive:
	docker run \
		-i \
		--rm \
		--mount src=$(PWD),target=/home,type=bind \
		avr-test bash

test:
	docker run \
		--rm \
		--mount src=$(PWD),target=/home,type=bind \
		avr-test gcc

bin/main: $(SRC_FILES)
	mkdir -p bin
	$(CC) -I $(INCLUDE) -O1 -mmcu=$(DEVICE) -o $@ $?

clean:
	rm -rf bin

.PHONY: clean build_containers build_container_avr interactive test