# custom-qkd-source


### On **Pi A** (set IP `192.168.2.1/24`):

Create a file:

```bash
sudo nano /etc/systemd/network/10-eth0.network
```


```ini
[Match]
Name=eth0

[Network]
Address=192.168.2.1/24
```

 Enable `systemd-networkd`:

```bash
sudo systemctl enable systemd-networkd
sudo systemctl restart systemd-networkd
```

Repeat similar steps on **Pi B**, but with a different address:

---

### On **Pi B** (set IP `192.168.2.2/24`):

```bash
sudo nano /etc/systemd/network/10-eth0.network
```

```ini
[Match]
Name=eth0

[Network]
Address=192.168.2.2/24
```

Then:

```bash
sudo systemctl enable systemd-networkd
sudo systemctl restart systemd-networkd
```

---

###  test:

```bash
ping 192.168.2.2  # from Pi A
ping 192.168.2.1  # from Pi B
```
