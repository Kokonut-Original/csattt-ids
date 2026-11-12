# Thực nghiệm chặn DNS và phục hồi IDS ngày 13 tháng 11 năm 2026

Đã dùng script DNS giả lập sẵn có, nguyên trạng, để đo IDS → IPS → IDS. IPS hoạt động tại namespace victim `.10`, chỉ queue DNS với Kali `.20`; không đổi mạng nghiên cứu hoặc ossec.conf. Snapshot nền là commit `c3a9d75` đã kiểm tích hợp; nhánh IPS phụ thuộc PR #15 đang chờ review.

| Pha | DNS request | DNS response | Exit script | EVE và Wazuh |
|---|---:|---:|---:|---|
| IDS trước | 40 | 40 NXDOMAIN | 0 | SID 1000004, allowed |
| IPS | 1 | 0 | 9 | SID 1000014, blocked |
| IDS sau rollback | 40 | 40 NXDOMAIN | 0 | SID 1000004, allowed |

Đây là một lượt script mỗi pha. Script dừng ở truy vấn bị timeout đầu tiên khi IPS bật, nên không gọi kết quả là “chặn 40 truy vấn”. Rule mới chỉ nhận marker `.phan…exfil.lab` của bài mô phỏng, chưa chứng minh phát hiện DNS tunnel thực tế.

[JSON bằng chứng đã lọc](ips-dns-drop-2026-11-13.json) ghi timestamp UTC, action hai hệ thống, exit code, request/response và hash pcap. Ngày tiêu đề theo giờ Việt Nam; log Suricata dùng PST, JSON giữ timestamp nguồn và UTC của lượt chạy để ghép, không đổi timezone host.

NFQUEUE báo **Accepted 12, Dropped 1, Replaced 0**, xử lý 13 gói và không lỗi. Counter kernel/user queue drop đều 0. Hai lượt benign trong IPS, trước và sau drop, đều chạy thành công: ping, HTTP, SSH hợp lệ và DNS không marker. Đây là đối chứng rằng DNS server vẫn hoạt động và không phải firewall chặn mọi DNS.

Kết thúc ở IDS AF_PACKET trên br-lab: bỏ các hook demo trong victim và override riêng, unit gốc được phục hồi. Hash suricata.yaml, local.rules và ossec.conf không đổi; firewall host, IPv4/route và network ID khớp backup. Cả ba container healthy, Suricata và Wazuh manager active. Capture toàn bridge không thấy IPv4 ngoài 172.28.0.0/24 và không có IPv6 trong khoảng đo. Không suy thành bảo đảm cô lập cho mọi lần chạy sau.

Raw log/pcap, full config/firewall và các lượt lỗi giữ cục bộ ngoài Git, có hash để đối chiếu. Chỉ JSON đã lọc được đưa vào PR. Hai lần setup ban đầu lỗi ở preflight; một lần thử FORWARD trên bridge nhận 0 gói NFQUEUE và làm benign DNS timeout. Các lượt đó bị loại khỏi kết quả chặn, đã rollback và được ghi riêng, không xếp là Wazuh bỏ sót. Sau đó mới thử và xác minh phương án namespace victim ở trên.

Giới hạn: một kịch bản giả lập, chưa đo FP/FN tổng quát, tải lớn, độ bền khi restart container hoặc fail-closed. Bypass được chủ ý bật để tránh giữ mất kết nối khi listener dừng. Chỉ xác minh Wazuh alerts.json, chưa xem Dashboard trong lượt này. Lab được để IDS để chờ review.

Cách vận hành và rollback: [lab/IPS-DNS.md](../../lab/IPS-DNS.md). PR cần thành viên khác review, không tự merge hoặc tạo Tag/Release.
