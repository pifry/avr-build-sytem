#define F_CPU 1000000  // CPU frequency for proper time calculation in delay function

#include <util/delay.h>

#include "hal.h"

int main(void)
{
    hal_init();

    for(;;)
    {
        set_light(1);
        _delay_ms(1000);  // delay for a second
    }

    return 0;  // the program executed successfully
}