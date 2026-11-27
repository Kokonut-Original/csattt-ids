# Bài tập lớn CSATTT — Suricata và Wazuh

BTL số 4 môn SEC1304, Nhóm 5: giám sát lưu lượng mô phỏng trong Docker lab, phát hiện bằng rule Suricata và chuyển EVE JSON vào Wazuh. Repo private phục vụ học tập và đánh giá; chỉ thử nghiệm trong subnet `172.28.0.0/24` thuộc lab được phép.

## Chạy và kiểm tra

Làm theo [hướng dẫn dựng lab](lab/README.md) để chuẩn bị bí mật ngoài repo, build image và khởi động ba container. Các script và log/pcap dùng mount cố định. Suricata/Wazuh chạy trên Ubuntu host; Compose không tự cài hoặc thay cấu hình hai dịch vụ này.

[Năm script mô phỏng](scripts/README.md) và [kiểm thử](tests/README.md) ghi rõ nơi chạy, SID và giới hạn. [Lượt kiểm tra tích hợp 13/11](docs/results/lab-reproducibility-2026-11-13.md) đã có cảnh báo năm SID ở EVE/Wazuh và một lượt benign không có SID BTL; đây chưa phải thống kê độ chính xác tổng quát. Năm rule IDS dùng action `alert`. Ca IPS DNS đã được kiểm riêng với rule `drop` SID 1000014.

## Nội dung repo

| Đường dẫn | Nội dung |
|---|---|
| `docs/` | [Báo cáo PDF](docs/SEC1304-Nhom5-Bao-cao-Bai-4.pdf), [slide PowerPoint](docs/SEC1304-Nhom5-Trinh-chieu.pptx), kết quả, minh chứng và bảng CLO |
| `src/suricata/` | Năm rule IDS trong `local.rules` và rule IPS DNS trong `ips/dns-demo.rules` |
| `lab/` | Compose, Dockerfile, startup và fixture giả sai |
| `scripts/` | Năm kịch bản chỉ chạy trong lab |
| `tests/` | Benign, kiểm thử rule và test dựng lại container trên CI |
| `.github/` | Workflow SAST/lint/test/secret scan và cấu hình cập nhật Actions |
| `CHANGELOG.md` | Lịch sử thay đổi và mốc phát hành |

## Kiểm soát và bàn giao

Thay đổi theo `feature/* → PR → develop`, tối thiểu một thành viên khác review trên GitHub trước merge. Không push trực tiếp main. Xem [quy trình đóng góp](CONTRIBUTING.md), [phạm vi và đạo đức](docs/ETHICS-CLO.md), [chính sách bảo mật](SECURITY.md), [bảng rà quy định GitHub](docs/GITHUB-CHECKLIST.md).

### Trạng thái ngày 27/11/2026

- Các PR #15, #17, #18, #19, #20, #21, #22 và #23 đã merge vào `develop`.
- Repo có hai tag [v1.0-midterm](https://github.com/Kokonut-Original/csattt-ids/tree/v1.0-midterm) và [v2.0-final](https://github.com/Kokonut-Original/csattt-ids/tree/v2.0-final). [Release v2.0-final](https://github.com/Kokonut-Original/csattt-ids/releases/tag/v2.0-final) đính kèm báo cáo PDF, video minh chứng và slide PowerPoint.
- Repo dùng [giấy phép MIT](LICENSE). Nhóm theo dõi công việc qua Issues, Milestones và bảng GitHub Projects **BTL Bài 4 - Nhóm 5**.

Không đưa mật khẩu, token, PCAP hoặc log thô, image hay snapshot VM lên repo. Repo BTL tách khỏi nghiên cứu NEXUS.

## IPS DNS tùy chọn

[Demo IPS/drop và rollback](lab/IPS-DNS.md) sử dụng script DNS nguyên trạng và chặn marker của bài trong namespace victim; xem [kết quả và phục hồi IDS](docs/results/ips-dns-drop-2026-11-13.md). Compose khởi động lab ở chế độ IDS. IPS DNS được bật riêng khi cần.
