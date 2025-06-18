// #include <stdio.h>

// #include "pico/stdlib.h"
// #include "hardware/pio.h"

// #include "pulse_detect.pio.h"

// #define ZERO_PIN 2
// #define ONE_PIN 3

// void setup_pio_input(PIO pio, uint sm, uint offset, uint pin) {
//     pio_sm_config c = detect_pulse_program_get_default_config(offset);
//     pio_sm_set_consecutive_pindirs(pio, sm, pin, 1, false);
//     pio_gpio_init(pio, pin);
//     sm_config_set_in_pins(&c, pin);
//     sm_config_set_fifo_join(&c, PIO_FIFO_JOIN_RX);
//     sm_config_set_clkdiv(&c, 1.0f);  // full speed
//     pio_sm_init(pio, sm, offset, &c);
//     pio_sm_set_enabled(pio, sm, true);
// }

// // void setup_pio_input(PIO pio, uint sm, uint offset, uint pin) {
// //     pio_sm_config c = detect_pulse_program_get_default_config(offset);

// //     // Configure pins 2, 3, 4 as inputs (so pin 4 can be read by PIO)
// //     pio_sm_set_consecutive_pindirs(pio, sm, 4, 1, false);
// //     for (int i = pin; i < pin + 3; i++) {
// //         pio_gpio_init(pio, i);
// //     }

// //     sm_config_set_in_pins(&c, 4);  // base pin for 'in pins' instruction (pin 2 or 3)
// //     sm_config_set_fifo_join(&c, PIO_FIFO_JOIN_RX);
// //     sm_config_set_clkdiv(&c, 1.0f);  // full speed

// //     pio_sm_init(pio, sm, offset, &c);
// //     pio_sm_set_enabled(pio, sm, true);
// // }


// void setup_pio_input(PIO pio, uint sm, uint offset, uint pulse_pin, uint gate_pin) {
//     pio_sm_config c = detect_pulse_program_get_default_config(offset);

//     // Initialize both pins
//     gpio_init(pulse_pin);
//     gpio_init(gate_pin);
//     gpio_set_dir(gate_pin, GPIO_IN);
//     gpio_pull_down(gate_pin);  // or _up based on logic level

//     // Configure both pins as inputs for PIO
//     pio_gpio_init(pio, pulse_pin);
//     pio_gpio_init(pio, gate_pin);
//     pio_sm_set_consecutive_pindirs(pio, sm, pulse_pin, 1, false);
//     pio_sm_set_consecutive_pindirs(pio, sm, gate_pin, 1, false);

//     // Set base pin to gate pin so `jmp pin` uses it
//     sm_config_set_in_pins(&c, gate_pin);

//     sm_config_set_fifo_join(&c, PIO_FIFO_JOIN_RX);
//     sm_config_set_clkdiv(&c, 1.0f);

//     pio_sm_init(pio, sm, offset, &c);
//     pio_sm_set_enabled(pio, sm, true);
// }



// int main() {
//     stdio_init_all();

//     // gpio_init(4);
//     // gpio_set_dir(4, GPIO_IN);

//     // gpio_pull_down(4);  // or gpio_pull_up(4); based on your wiring



//     PIO pio = pio0;
//     uint offset = pio_add_program(pio, &detect_pulse_program);

//     uint sm_zero = 0;
//     uint sm_one  = 1;

//     setup_pio_input(pio, sm_zero, offset, ZERO_PIN, 4);
//     setup_pio_input(pio, sm_one, offset, ONE_PIN, 4);

//     //  setup_pio_input(pio, sm_zero, offset, ZERO_PIN);
//     // setup_pio_input(pio, sm_one, offset, ONE_PIN);

//     while (true) {
//         if (!pio_sm_is_rx_fifo_empty(pio, sm_zero)) {
//             pio_sm_get_blocking(pio, sm_zero);
//             printf("0");
//         }
//         if (!pio_sm_is_rx_fifo_empty(pio, sm_one)) {
//             pio_sm_get_blocking(pio, sm_one);
//             printf("1");
//         }
//     }
// }


#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/pio.h"
#include "pulse_detect.pio.h"

#define ZERO_PIN 4  // Pulse 0
#define ONE_PIN  5  // Pulse 1
#define GATE0_PIN 2 // Gate for Pulse 0
#define GATE1_PIN 3 // Gate for Pulse 1

void setup_pio_input(PIO pio, uint sm, uint offset, uint pulse_pin, uint gate_pin) {
    pio_sm_config c = detect_pulse_program_get_default_config(offset);

    // Initialize pins
    gpio_init(pulse_pin);
    gpio_init(gate_pin);
    gpio_set_dir(pulse_pin, GPIO_IN);
    gpio_set_dir(gate_pin, GPIO_IN);
    gpio_pull_down(pulse_pin);
    gpio_pull_down(gate_pin);

    // PIO needs both pulse and gate pin initialized
    pio_gpio_init(pio, pulse_pin);
    pio_gpio_init(pio, gate_pin);

    // Base pin is pulse_pin, and we assume gate_pin = pulse_pin + 2
    sm_config_set_in_pins(&c, pulse_pin);
    pio_sm_set_consecutive_pindirs(pio, sm, pulse_pin, 3, false);  // Covers pulse, (pulse+1), gate

    sm_config_set_fifo_join(&c, PIO_FIFO_JOIN_RX);
    sm_config_set_clkdiv(&c, 1.0f);

    pio_sm_init(pio, sm, offset, &c);
    pio_sm_set_enabled(pio, sm, true);
}

int main() {
    stdio_init_all();

    PIO pio = pio0;
    uint offset = pio_add_program(pio, &detect_pulse_program);

    uint sm_zero = 0;
    uint sm_one  = 1;

    setup_pio_input(pio, sm_zero, offset, GATE0_PIN, ZERO_PIN);
    setup_pio_input(pio, sm_one,  offset, GATE1_PIN,  ONE_PIN);

    while (true) {
        if (!pio_sm_is_rx_fifo_empty(pio, sm_zero)) {
            pio_sm_get_blocking(pio, sm_zero);
            printf("0");
        }
        if (!pio_sm_is_rx_fifo_empty(pio, sm_one)) {
            pio_sm_get_blocking(pio, sm_one);
            printf("1");
        }
    }
}
