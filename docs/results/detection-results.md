# Kết quả kiểm thử rule Suricata – Tuần 2 (Duy)

Môi trường: lab Docker, Suricata 8.0.6 nghe `br-lab` (172.28.0.0/24).
Kali = 172.28.0.20, victim = 172.28.0.10, server3 = 172.28.0.30.

## Test lưu lượng bình thường (kiểm tra FP)
Ping 3 gói, mở web 1 lần, SSH đúng mật khẩu 1 lần, tra DNS 3 lần → **0 cảnh báo** cho cả 5 rule.

## Test tấn công (kiểm tra TP/FN)

| sid | Rule | Test tấn công | Số alert | Kết quả | Ghi chú |
|---|---|---|---|---|---|
| 1000002 | ICMP flood | live `ping -c 50 -i 0.2` | 2 | TP | `ping -c 3`: 0 alert |
| 1000002 | ICMP flood | pcap 03 (420.453 gói) | 1 | TP | threshold gộp cảnh báo |
| 1000003 | Port scan | pcap 01 (1.009 gói SYN) | 1 | TP | |
| 1000004 | SSH brute-force rev 2 (thêm flow:to_server) | pcap 02 (4 lần thử / 3,2 giây) | 1 | TP | hạ ngưỡng 5 → 3 vì pcap chỉ có 4 lần thử |
| 1000005 | DNS tunnel | pcap 04 | 0 | FN | pcap bắt trên loopback qua DNS nội bộ Docker, không đi qua mạng |
| 1000005 | DNS tunnel | live, 40 truy vấn tới 172.28.0.10 | 2–3 | TP | đổi DNS đích sang máy trong lab |
| 1000006 | Reverse shell rev 1 | pcap 01 (port scan) | 1 | **FP** | nmap gõ trúng cổng 4444 |
| 1000006 | Reverse shell rev 2 | pcap 01 (port scan) | 0 | Hết FP | đổi sang bắt SYN-ACK từ cổng 4444 |
| 1000006 | Reverse shell rev 2 | pcap 05 | 1 | TP | |

## Hạn chế đã biết
- Reverse shell: kẻ tấn công đổi cổng khác 4444 thì bỏ sót.
- SSH brute-force: ngưỡng 3 lần / 60 giây có thể báo nhầm nếu người dùng đăng nhập lại nhiều lần.
- DNS tunnel: chỉ đếm số truy vấn, chưa xét độ dài tên miền.
