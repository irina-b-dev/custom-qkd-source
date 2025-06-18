

#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/pio.h"
#include "hardware/clocks.h"
#include "pulse.pio.h"

#define LASER_PIN 2  // GPIO pin for output pulse
#define EN_PIN 3



void laser_pulse_forever(PIO pio, uint sm, uint offset, uint pin) {


    laser_pulse_program_init(pio, sm, offset, pin);
    pio_sm_set_enabled(pio, sm, true);

    printf("Blinking pin %d at fsafasdHz\n", pin);
}


int main() {
    stdio_init_all();

    PIO pio[2];
    uint sm[2];
    uint offset[2];

    bool rc = pio_claim_free_sm_and_add_program_for_gpio_range(&laser_pulse_program, &pio[0], &sm[0], &offset[0], LASER_PIN, 2, true);
    hard_assert(rc);
    printf("Loaded program at %u on pio %u\n", offset[0], PIO_NUM(pio[0]));

    gpio_set_drive_strength(LASER_PIN, GPIO_DRIVE_STRENGTH_12MA);
    //uint offset = pio_add_program(pio, &laser_pulse_program);
    laser_pulse_forever(pio[0], sm[0], offset[0], LASER_PIN);

    gpio_init(EN_PIN);
    gpio_set_dir(EN_PIN, true);
    gpio_put(EN_PIN, true);

    while (1) {
        tight_loop_contents(); // Do nothing, pulse runs in hardware
    }
}

