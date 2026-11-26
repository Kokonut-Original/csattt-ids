# Script kiểm thử rule Suricata
Yêu cầu: lab đang chạy (`docker-compose up -d`), Suricata nghe `br-lab`, ghi log vào `~/lab/log`.

| Script | Kiểm tra |
|---|---|
| `bash tests/normal_traffic.sh` | Lưu lượng bình thường không bị báo nhầm (FP) |
| `bash tests/replay_pcap.sh [thư-mục-pcap]` | Chạy lại 5 pcap tấn công |
| `bash tests/icmp_flood_live.sh normal\|attack` | ICMP flood live 2 chiều |
| `bash tests/dns_tunnel_live.sh` | DNS tunnel live |

## Kiểm tra hiện hành

`normal_traffic.sh` dùng `LAB_STATE_DIR`, đọc mật khẩu qua stdin, không xóa log. Hướng dẫn cũ và script replay/live khác phản ánh lab tuần 2 của Duy; không chạy các script đó với mặc định `~/lab/log` trên bản tích hợp mà chưa đối chiếu đường dẫn.

`compose_smoke.sh` chỉ dùng trên runner GitHub Linux dùng một lần: từ chối thay container đang tồn tại, tạo credential ngẫu nhiên cục bộ, build/up healthy, chạy benign, kiểm script chỉ đọc và dữ liệu pcap còn sau force-recreate. CI không chạy các script tấn công hoặc xác minh Wazuh; bằng chứng 5 kịch bản từ laptop nằm ở `docs/results/lab-reproducibility-2026-11-13.*`.

Workflow `BTL quality` gồm Semgrep local policy, ShellCheck, Gitleaks lịch sử Git và Compose integration. Kết quả phải đọc trên đúng SHA cuối cùng của PR; có file workflow chưa có nghĩa đã chạy thành công. Các image scanner dùng tag cập nhật; cần xem phiên bản trong log khi so sánh lượt chạy.

`python3 -m unittest discover -s tests -p 'test_*.py' -v` kiểm rollback comparator bằng snapshot văn bản, không đụng firewall. CI build helper IPS và kiểm tool availability trong container không có host mounts/NET_ADMIN; không gọi `ips_mode.sh enable`. Thực nghiệm chặn thật chỉ thực hiện trên laptop lab đã được phép và lưu bằng chứng riêng.
