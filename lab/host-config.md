# Cấu hình host đã đối chiếu trên lab tích hợp

Đây là các phần cấu hình liên quan BTL đã đọc trên Ubuntu, không phải toàn bộ cấu hình đã làm sạch để cài mới Wazuh. Không chép đè file host đang dùng chung cho nghiên cứu.

Suricata 7.0.3: `HOME_NET: "[172.28.0.0/24]"`, `af-packet` nghe interface `br-lab`, `default-rule-path: /var/lib/suricata/rules`, `rule-files` chứa `local.rules`. File rule trong repo `src/suricata/local.rules` có năm SID 1000001–1000005, hành động `alert`.

Wazuh manager package `4.14.9-1`: phần thu EVE trong `/var/ossec/etc/ossec.conf`:

```xml
<localfile>
  <log_format>json</log_format>
  <location>/var/log/suricata/eve.json</location>
</localfile>
```

Trên máy mới cần cài các thành phần host, sao lưu trước sửa, cấu hình tầm nhìn interface và quyền log đúng phiên bản; chạy kiểm tra cấu hình rồi mới restart dịch vụ. Trên lab hiện tại, EVE → Wazuh đã hoạt động nên lượt đồng bộ Compose không chỉnh ossec.conf hoặc restart Wazuh. Không sửa agent Windows, port forwarding hoặc card NEXUS để dựng BTL.

Bằng chứng 13/11 là đối chiếu EVE và alerts.json của manager, chưa tự kiểm toàn bộ indexer/Dashboard từ máy mới. Cần bổ sung hướng dẫn cài host và một lượt tái lập độc lập trước khi gọi đây là bộ dựng lại toàn hệ thống từ đầu.
