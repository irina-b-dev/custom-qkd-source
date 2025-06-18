#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <time.h>
#include <arpa/inet.h>
#include <sys/socket.h>

#define SERIAL_PORT "/dev/ttyACM0"
#define SERVER_PORT 9000
#define KEY_LENGTH 512

char sent_bits[KEY_LENGTH];
char sent_bases[KEY_LENGTH];



#define BLOCK_SIZE 4

// Helper: XOR parity over block
char compute_parity(const char *bits, int start, int len) {
    int p = 0;
    for (int i = 0; i < len; i++) {
        if (bits[start + i] == '1') p ^= 1;
    }
    return p ? '1' : '0';
}

// Only bits where match_mask == '1' are part of sifted key
void send_block_parities(int client_fd, const char *bits, const char *mask, int key_len) {
    for (int i = 0; i < key_len; i += BLOCK_SIZE) {
        char block[BLOCK_SIZE];
        int idx = 0;
        for (int j = i; j < i + BLOCK_SIZE && j < key_len; j++) {
            if (mask[j] == '1') {
                block[idx++] = bits[j];
            }
        }
        char parity = compute_parity(block, 0, idx);
        send(client_fd, &parity, 1, 0);
    }
}






void generate_test_data() {
    srand(time(NULL));
    for (int i = 0; i < KEY_LENGTH; i++) {
        sent_bits[i] = (rand() % 2) ? '0' : '0';
        sent_bases[i] = (rand() % 2) ? '+' : 'x';
    }
}

int main() {
    generate_test_data();  

    // --- Set up TCP server ---
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in server_addr = {
        .sin_family = AF_INET,
        .sin_port = htons(SERVER_PORT),
        .sin_addr.s_addr = INADDR_ANY
    };
    bind(server_fd, (struct sockaddr*)&server_addr, sizeof(server_addr));
    listen(server_fd, 1);
    printf("Waiting for Pi B to connect...\n");

    int client_fd = accept(server_fd, NULL, NULL);
    printf("Pi B connected!\n");

    // --- Receive bases from Pi B ---
    char recv_bases[KEY_LENGTH];
    int received = 0;
    while (received < KEY_LENGTH) {
        int n = recv(client_fd, recv_bases + received, KEY_LENGTH - received, 0);
        if (n <= 0) break;
        received += n;
    }

    // --- Compare bases and prepare match mask ---
    char match_mask[KEY_LENGTH];
    for (int i = 0; i < KEY_LENGTH; i++) {
        match_mask[i] = (recv_bases[i] == sent_bases[i]) ? '1' : '0';
    }

    // --- Send match mask to Pi B ---
    send(client_fd, match_mask, KEY_LENGTH, 0);

    // --- Optional: Print sifted key ---
    printf("Sifted key: ");
    for (int i = 0; i < KEY_LENGTH; i++) {
        if (match_mask[i] == '1') {
            putchar(sent_bits[i]);
        }
    }
    putchar('\n');


    // After sending match_mask:
    for (int i = 0; i < KEY_LENGTH; i++) {
        if (match_mask[i] == '1') {
            send(client_fd, &sent_bits[i], 1, 0);
        }
    }


    send_block_parities(client_fd, sent_bits, match_mask, KEY_LENGTH);

    close(client_fd);
    close(server_fd);
    return 0;
}
