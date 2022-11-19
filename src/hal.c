#include "hal.h"

#include <avr/io.h>


void hal_init(void) {
    DDRD |= (1 << PD6);  // make PD6 an output
}

void set_light(int value) {
    PORTD ^= (1 << PD6);  // toggle PD6
}