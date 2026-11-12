# Kiểm tra dựng lại lab tích hợp ngày 13 tháng 11 năm 2026

Đã dựng lại ba container từ Compose/Dockerfile trên nhánh `feature/lab-reproducibility`, giữ project `lab`, network `lab_lab_net` và bridge `br-lab`. Cả ba container healthy; DNS nội bộ tự khởi động và trả NXDOMAIN cho TXT giả `exfil.lab`. Script được mount sẵn vào Kali/victim; log/pcap và bí mật nằm ngoài repo.

Đơn vị kiểm tra là một lượt gọi script có giới hạn. Kết quả dưới đây là smoke/regression test trên lab tích hợp, không phải tỷ lệ phát hiện tổng quát. [Bằng chứng JSON đã lọc](lab-reproducibility-2026-11-13.json) ghi mốc UTC, exit code, các alert và image ID. Ngày tiêu đề theo giờ Việt Nam; timestamp UTC trong JSON thuộc tối 12/11.

| Lượt | Kết quả thực thi | Suricata EVE | Wazuh alerts.json |
|---|---|---|---|
| Benign: 3 ping, 1 HTTP, 1 SSH hợp lệ, 3 DNS | Thành công | Không có SID BTL mới | Không có SID BTL mới |
| Port scan | Thành công | SID 1000001; đồng thời SID 1000002 | SID 1000001; đồng thời SID 1000002 |
| SSH thử danh sách sai, sau khi chờ 65 giây | Thành công | SID 1000002 | SID 1000002 |
| ICMP flood, giới hạn 2 giây | Thành công | SID 1000003 | SID 1000003 |
| 40 truy vấn DNS giả tới .10 | Thành công | SID 1000004 | SID 1000004 |
| Reverse shell bằng script hai vai sẵn có; gửi exit kết thúc | Thành công | SID 1000005 | SID 1000005 |

Capture toàn bridge trong khoảng kiểm tra không có gói IPv4 ra ngoài `172.28.0.0/24`; số gói IPv6 ghi trong JSON. Capture toàn bridge là bằng chứng riêng, không dùng capture đã lọc của từng script để suy ra không có lưu lượng ngoài lab. Bridge có NAT nên đây không phải cam kết air-gap.

Network ID và SHA256 của `suricata.yaml`, rule đang nạp, `ossec.conf` không đổi trước/sau. Không sửa Wazuh manager/agent Windows hoặc cấu hình NEXUS. Không xóa log để đo; dùng offset đầu mỗi lượt và chờ pipeline Wazuh ghi cảnh báo.

Trước thay container đã sao lưu Compose, file root/tmp, pcap/log, packages, metadata và image snapshot cục bộ; hash file sao lưu đã được đối chiếu. Bản backup/raw pcap/raw log/metadata có thể chứa bí mật nên không đưa vào repo. Lần startup đầu lỗi do không có service script rsyslog; startup đã đổi sang daemon trực tiếp, sau đó rebuild và chạy các kiểm tra trên thành công.

Giới hạn: Suricata tích hợp là 7.0.3, khác 8.0.6 trong kết quả tuần 2 của Duy. Nmap cũng khớp rule SSH vì rule đếm SYN tới cổng 22, không đọc kết quả mật khẩu. Một lượt benign không đủ khẳng định không có báo giả; không tính FP/FN từ số dòng alert. Chưa kiểm chứng từng cảnh báo bằng Dashboard trong phiên này. IPS/drop, báo cáo/slide/video và review độc lập là các việc riêng.

Đã kiểm lại toàn bộ sáu lượt trên image cuối sau khi đổi hai mật khẩu test cục bộ và bỏ SSH host key khỏi image build; mỗi container sinh key riêng. JSON là lượt cuối. File Compose cũ ngoài repo đã chuyển thành entrypoint tham chiếu repo; model đã được so sánh bằng nhau.
