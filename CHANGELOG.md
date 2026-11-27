# Changelog

## v2.0-final — 27/11/2026

- Thêm giấy phép MIT, báo cáo PDF bản cuối và slide thuyết trình của Nhóm 5.
- Lưu ảnh Wazuh Discover tại `docs/evidence/w3-dashboard/` và đưa vào Hình 11 của báo cáo.
- Tạo tag `v1.0-midterm` cho mốc giữa kỳ và `v2.0-final` cho mốc nộp cuối kỳ. [Release v2.0-final](https://github.com/Kokonut-Original/csattt-ids/releases/tag/v2.0-final) đính kèm PDF, video minh chứng và PowerPoint.

Các mục dưới đây ghi trạng thái tại thời điểm rà ngày 13/11/2026.

## Chưa phát hành — 13/11/2026

- Đưa package và startup vào image build; DNS nội bộ tự bật, không upstream.
- Đồng bộ mount script, log, pcap và fixture SSH sai có chủ đích; chuyển credential khỏi Compose/README/test sang file cục bộ.
- Kiểm chứng một lượt benign và đủ năm script trên Suricata/Wazuh tích hợp; lưu JSON bằng chứng đã lọc, không xóa log chạy.
- Bổ sung README/quy trình review, checklist quy định, SAST/lint/test/secret-scan CI và cấu hình Dependabot cho Actions.

Chưa tạo tag hoặc release. Các kết quả tuần 1–2 của Duy giữ nguyên trong `docs/evidence/` và `docs/results/detection-results.md`.

### IPS DNS demo — chưa phát hành

- Thêm chuyển đổi NFQUEUE trong namespace victim, rule marker SID 1000014 và phục hồi IDS gốc; giữ firewall host/mạng nghiên cứu.
- Đo IDS 40/40 phản hồi → IPS 1/0 với verdict drop → IDS 40/40; đối chiếu Wazuh và benign trước/sau drop.
- Thêm 6 kiểm thử hồi quy cho so sánh firewall và build-check helper trên CI; CI không tự bật IPS trên runner.
