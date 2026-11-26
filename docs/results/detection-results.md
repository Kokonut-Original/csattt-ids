# Kết quả kiểm thử rule Suricata – Tuần 2 (Duy)

Môi trường: lab Docker, Suricata 8.0.6 nghe `br-lab` (172.28.0.0/24).
Kali = 172.28.0.20, victim = 172.28.0.10, server3 = 172.28.0.30.
Rule: `src/suricata/local.rules`. Bằng chứng: `docs/evidence/w2-duy/`. Script test: `tests/`.

## Danh sách rule (sid theo thứ tự kịch bản)

| sid | Kịch bản | Cách phát hiện |
|---|---|---|
| 1000001 | 01 Quét cổng | ≥ 20 gói SYN / 5 giây từ cùng một IP |
| 1000002 | 02 Brute-force SSH | ≥ 3 kết nối mới tới cổng 22 / 60 giây |
| 1000003 | 03 ICMP flood | ≥ 20 gói ping / 5 giây |
| 1000004 | 04 DNS tunnel | ≥ 10 truy vấn DNS / 10 giây |
| 1000005 | 05 Reverse shell | cổng 4444 chấp nhận kết nối (SYN-ACK) về máy trong lab |

## Test lưu lượng bình thường (kiểm tra FP)
Ping 3 gói, mở web 1 lần, SSH đúng mật khẩu 1 lần, tra DNS 3 lần → **0 cảnh báo** cho cả 5 rule (ảnh `03`, file `00_normal-all.txt`).
Victim không chạy DNS server nên truy vấn DNS bị từ chối, nhưng gói vẫn đi qua mạng lab nên vẫn kiểm tra được rule DNS.

## Test tấn công (kiểm tra TP/FN)

| sid | Rule | Test tấn công | Số alert | Kết quả | Ghi chú |
|---|---|---|---|---|---|
| 1000001 | Port scan | pcap 01 (1.009 gói SYN) | 1 | TP | |
| 1000002 | SSH brute-force | pcap 02 (4 lần thử / 3,2 giây) | 1 | TP | hạ ngưỡng 5 → 3 theo số liệu pcap; rev 2 thêm `flow:to_server` |
| 1000003 | ICMP flood | pcap 03 (420.453 gói) | 1 | TP | |
| 1000003 | ICMP flood | live `ping -c 50 -i 0.2` | 2 | TP | live `ping -c 3`: 0 alert |
| 1000004 | DNS tunnel | pcap 04 | 0 | FN | pcap bắt trên loopback, truy vấn gửi tới DNS nội bộ Docker (127.0.0.11), không đi qua mạng lab |
| 1000004 | DNS tunnel | live, 40 truy vấn tới 172.28.0.10 | 2 | TP | đổi DNS đích sang máy trong lab |
| 1000005 | Reverse shell | pcap 05 | 1 | TP | |

## Quá trình chỉnh rule
- **Reverse shell rev 1** bắt gói SYN tới cổng 4444 → **báo nhầm** khi nmap quét trúng cổng 4444 (`history/05_reverse_shell-rev1-FP.txt`). **Rev 2** chỉ bắt SYN-ACK từ cổng 4444, tức là khi cổng thật sự chấp nhận kết nối → hết báo nhầm.
- **SSH brute-force**: ngưỡng ban đầu 5 lần sẽ bỏ sót vì pcap chỉ có 4 lần thử → hạ xuống 3.

## Hạn chế đã biết
- Reverse shell: kẻ tấn công đổi cổng khác 4444 thì bỏ sót.
- SSH brute-force: ngưỡng 3 lần / 60 giây có thể báo nhầm nếu người dùng đăng nhập lại nhiều lần.
- DNS tunnel: chỉ đếm số truy vấn, chưa xét độ dài tên miền.

## Chạy lại test
| Script | Ảnh tương ứng |
|---|---|
| `bash tests/normal_traffic.sh` | `03-normal-all.png` |
| `bash tests/replay_pcap.sh <thư-mục-pcap>` | `04-pcap-tests.png` |
| `bash tests/icmp_flood_live.sh normal` / `attack` | `05`, `06` |
| `bash tests/dns_tunnel_live.sh` | `07-dnstunnel-live.png` |

Yêu cầu: lab đang chạy (`docker-compose up -d`), Suricata nghe `br-lab` và ghi log vào `~/lab/log`.

## Ghi chú đánh số
Ngày 30/10 sid được sắp lại theo thứ tự kịch bản (trước đó đánh theo thứ tự viết rule). File trong `history/` giữ sid cũ.
