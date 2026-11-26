# Bài tập lớn CSATTT — Suricata và Wazuh

BTL số 4 môn SEC1304, nhóm 4: giám sát lưu lượng mô phỏng trong Docker lab, phát hiện bằng rule Suricata và chuyển EVE JSON vào Wazuh. Repo private phục vụ học tập và đánh giá; chỉ thử nghiệm trong subnet `172.28.0.0/24` thuộc lab được phép.

## Chạy và kiểm tra

Làm theo [hướng dẫn dựng lab](lab/README.md) để chuẩn bị bí mật ngoài repo, build image và khởi động ba container. Các script và log/pcap dùng mount cố định. Suricata/Wazuh chạy trên Ubuntu host; Compose không tự cài hoặc thay cấu hình hai dịch vụ này.

[Năm script mô phỏng](scripts/README.md) và [kiểm thử](tests/README.md) ghi rõ nơi chạy, SID và giới hạn. [Lượt kiểm tra tích hợp 13/11](docs/results/lab-reproducibility-2026-11-13.md) đã có cảnh báo năm SID ở EVE/Wazuh và một lượt benign không có SID BTL; đây chưa phải thống kê độ chính xác tổng quát. Rule hiện dùng `alert`; IPS/drop vẫn đang theo dõi ở Issue #8.

## Nội dung repo

| Đường dẫn | Nội dung |
|---|---|
| `docs/` | Kết quả, bằng chứng đã lọc, bảng CLO/đạo đức; báo cáo/slide cuối cần được nhóm bổ sung |
| `src/suricata/` | Năm rule `local.rules` |
| `lab/` | Compose, Dockerfile, startup và fixture giả sai |
| `scripts/` | Năm kịch bản chỉ chạy trong lab |
| `tests/` | Benign, kiểm thử rule và test dựng lại container trên CI |
| `.github/` | Workflow SAST/lint/test/secret scan và cấu hình cập nhật Actions |
| `CHANGELOG.md` | Lịch sử thay đổi đã thực hiện, chưa phải Tag/Release |

## Kiểm soát và bàn giao

Thay đổi theo `feature/* → PR → develop`, tối thiểu một thành viên khác review trên GitHub trước merge. Không push trực tiếp main. Xem [quy trình đóng góp](CONTRIBUTING.md), [phạm vi và đạo đức](docs/ETHICS-CLO.md), [chính sách bảo mật](SECURITY.md), [bảng rà quy định GitHub](docs/GITHUB-CHECKLIST.md).

PR hiện tại: #15. Tag `v1.0-midterm`, `v2.0-final` và Release có PDF/video do Long tự tạo sau khi kiểm tra bộ nộp; không coi tên milestone là tag đã tồn tại. Không đưa mật khẩu, token, pcap/log thô hoặc image/snapshot VM lên repo. Repo BTL tách khỏi nghiên cứu NEXUS.
