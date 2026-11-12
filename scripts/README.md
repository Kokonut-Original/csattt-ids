# Script mô phỏng BTL

Chỉ chạy trong Docker lab `172.28.0.0/24` theo [hướng dẫn lab](../lab/README.md). Script được mount chỉ đọc vào Kali và victim. Pcap/output lưu ở `/root/pcap`, ngoài repo. Dừng capture bằng trap của đúng PID; không xóa log dịch vụ.

| Script | Nơi chạy | SID mong đợi |
|---|---|---|
| `01_port_scan.sh` | Kali | 1000001 |
| `02_ssh_bruteforce.sh` | Kali | 1000002 |
| `03_icmp_flood.sh` | Kali | 1000003 |
| `04_dns_tunnel_sim.sh` | Kali, DNS tới victim .10 | 1000004 |
| `05_reverse_shell.sh attacker` / `victim` | Kali / victim tương ứng | 1000005 |

Không thay đích sang host hoặc mạng ngoài. Script SSH dùng danh sách sai có chủ đích, không phải công cụ dò tài khoản thật. Phần reverse shell giữ nguyên mô phỏng cũ, kết thúc bằng `exit`. Không public payload hoặc pcap của lab.
