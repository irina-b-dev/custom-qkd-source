#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <time.h>
#include <arpa/inet.h>

#define SERIAL_PORT "/dev/ttyACM0"
#define SERVER_IP   "192.168.2.1"  // Pi A's IP
#define SERVER_PORT 9000
#define BUF_SIZE 1024
#define KEY_LENGTH 512  // Number of bits to collect

char random_basis() {
    return (rand() % 2) ? '+' : 'x';  // '+' = rectilinear, 'x' = diagonal
}




#define BLOCK_SIZE 4

char compute_parity(const char *bits, int len) {
    int p = 0;
    for (int i = 0; i < len; i++) {
        if (bits[i] == '1') p ^= 1;
    }
    return p ? '1' : '0';
}

void correct_errors(int sock, char *bits, char *mask, int key_len) {
    for (int i = 0; i < key_len; i += BLOCK_SIZE) {
        char local_block[BLOCK_SIZE];
        int idx = 0, bit_pos[BLOCK_SIZE], actual_len = 0;

        for (int j = i; j < i + BLOCK_SIZE && j < key_len; j++) {
            if (mask[j] == '1') {
                local_block[idx] = bits[j];
                bit_pos[idx] = j;
                idx++;
            }
        }

        actual_len = idx;
        if (actual_len == 0) continue;

        char remote_parity;
        recv(sock, &remote_parity, 1, 0);
        char local_parity = compute_parity(local_block, actual_len);

        if (remote_parity != local_parity && actual_len == 1) {
            // Flip the bit
            bits[bit_pos[0]] = (bits[bit_pos[0]] == '0') ? '1' : '0';
        }
    }
}

 




int main() {
    srand(time(NULL));

    // --- Open USB serial to Pico ---
    int serial_fd = open(SERIAL_PORT, O_RDONLY | O_NOCTTY);
    if (serial_fd < 0) {
        perror("Error opening serial port");
        return 1;
    }

    struct termios tty;
    tcgetattr(serial_fd, &tty);
    cfsetispeed(&tty, B115200);
    cfmakeraw(&tty);
    tcsetattr(serial_fd, TCSANOW, &tty);

    // --- Connect to Pi A over TCP ---
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in server_addr = {
        .sin_family = AF_INET,
        .sin_port = htons(SERVER_PORT),
        .sin_addr.s_addr = inet_addr(SERVER_IP)
    };

    if (connect(sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        perror("Error connecting to Pi A");
        return 1;
    }

    printf("Connected to Pi A\n");

    char bits[KEY_LENGTH];
    char bases[KEY_LENGTH];

    int count = 0;

    // --- Read bits from USB, send bases to Pi A ---
    while (count < KEY_LENGTH) {
        char bit;
        int n = read(serial_fd, &bit, 1);
        if (n > 0 && (bit == '0' || bit == '1')) {
            char basis = random_basis();
            bits[count] = bit;
            bases[count] = basis;
            count++;
        }
    }

    // --- Send chosen bases to Pi A ---
    send(sock, bases, KEY_LENGTH, 0);

    // --- Receive match info from Pi A ---
    char match_mask[KEY_LENGTH];

    int received = 0;
    while (received < KEY_LENGTH) {
        int n = recv(sock, match_mask + received, KEY_LENGTH - received, 0);
        if (n <= 0) break;
        received += n;
    }


    // --- Sift key ---
    printf("Final key (sifted):\n");
    for (int i = 0; i < KEY_LENGTH; i++) {
        if (match_mask[i] == '1') {
            putchar(bits[i]);
        }
    }
    putchar('\n');


    ///////////////////////////////////

    char expected_bits[KEY_LENGTH];  // stores expected bits from Pi A
int sifted_index = 0;

for (int i = 0; i < KEY_LENGTH; i++) {
    if (match_mask[i] == '1') {
        char bit;
        int n = recv(sock, &bit, 1, 0);
        if (n != 1) {
            fprintf(stderr, "Error receiving expected bit\n");
            exit(1);
        }
        expected_bits[i] = bit;
    } else {
        expected_bits[i] = 'x';  // placeholder for unused bits
    }
}



////////////////////////////////////////////////////
    correct_errors(sock, bits, match_mask, KEY_LENGTH);

    printf("Corrected key:\n");
    for (int i = 0; i < KEY_LENGTH; i++) {
        if (match_mask[i] == '1') {
            putchar(bits[i]);
        }
    }
    putchar('\n');
////////////////////////////////////////





    int error_count = 0;
    int sifted_count = 0;

    for (int i = 0; i < KEY_LENGTH; i++) {
        if (match_mask[i] == '1') {
            sifted_count++;
            if (bits[i] != expected_bits[i]) {
                error_count++;
            }
        }
    }

    double qber = (sifted_count > 0) ? ((double)error_count / sifted_count) * 100.0 : 0.0;

    printf("QBER: %.2f%% (%d errors out of %d sifted bits)\n", qber, error_count, sifted_count);


    close(serial_fd);
    close(sock);
    return 0;
}



