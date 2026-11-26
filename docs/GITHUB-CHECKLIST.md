# Đối chiếu quy định GitHub và bộ nộp SEC1304

Ngày kiểm tra: 13/11/2026, giờ Việt Nam. Căn cứ: mục 1 “Quy định chung cho mọi bài tập lớn”, Bài 4 và các lưu ý cuối trong tài liệu thầy `danh-muc-10-bai-tap-lon-csattt (2).docx` do Long cung cấp. Yêu cầu trong đề là tiêu chí đối chiếu, không tự chứng minh nhóm đã hoàn thành.

Kết quả tổng thể: lab đã dựng lại và có kiểm chứng năm kịch bản, nhưng repo/bộ nộp chưa đạt toàn bộ quy định. Những thay đổi mới nằm trong [PR #15](https://github.com/Kokonut-Original/csattt-ids/pull/15), chưa merge vào develop/main và chưa được thành viên khác review. “Đạt ở PR” chỉ nói phần đã có trên nhánh PR; không được đọc thành đã phát hành.

| Yêu cầu theo đề | Trạng thái | Bằng chứng đã đọc hoặc kiểm tra | Việc còn thiếu |
|---|---|---|---|
| Repo private | Đạt | API repo trả `private: true`, owner cá nhân Kokonut-Original | Giữ private; không public để bật tính năng |
| Repo lớp/khoa và quyền giảng viên | Chưa đạt/chưa xác minh | Repo hiện thuộc tài khoản cá nhân; chưa xác nhận giảng viên đã được mời | Chốt với thầy mô hình repo; chưa có tài khoản giảng viên để đối chiếu. Repo cá nhân không có role Maintain độc lập |
| README mô tả và cách chạy | Đạt ở PR | [README](../README.md), [lab README](../lab/README.md) | Review rồi merge; kiểm chứng một người khác dựng theo tài liệu |
| Cấu trúc docs/src/lab/tests/scripts | Đạt ở PR | Các thư mục có nội dung; source rule ở `src/suricata/` | Thêm báo cáo/slide vào docs khi nhóm chuẩn bị xong |
| CHANGELOG.md | Đạt ở PR | [CHANGELOG](../CHANGELOG.md) | Giữ trạng thái chưa phát hành tới khi Long tạo release |
| Có main, develop và feature/* | Đạt | main `bb2b5ab`, develop `3d1807c`, feature/lab-reproducibility trong PR #15 | Main hiện chưa nhận bản tích hợp mới |
| Mọi thay đổi qua PR, không push thẳng main | Chưa đạt toàn bộ lịch sử | Phiên này chỉ thay feature và mở PR vào develop; main vẫn có commit thao tác lab cũ, chưa rà hết lịch sử quy trình | Tuân thủ từ PR hiện tại; không sửa lịch sử để làm giả việc đã review |
| Ít nhất một review của thành viên khác | Chưa đạt | API review PR #6 trả rỗng; [PR #15](https://github.com/Kokonut-Original/csattt-ids/pull/15) chưa có review lúc rà | Long sẽ nhờ bạn trên lớp; bạn cần gửi review/approval thật trên GitHub trên diff cuối |
| Cưỡng chế PR/review trên nhánh | Chưa đạt | API main và develop đều `protected: false`; rulesets trả 403 yêu cầu Pro hoặc public | Giữ quy trình thủ công. Không mua gói hoặc đổi public trong phạm vi này |
| Conventional Commits và mỗi commit gắn Issue | Chưa đạt toàn bộ lịch sử; commit mới đạt | Commit mới có `lab: ... (#14)`; commit cũ trên main `bb2b5ab` không gắn Issue trong message | Giữ convention cho commit tiếp theo, không rewrite lịch sử cũ |
| GitHub Issues theo dõi việc thật | Đạt | [#7](https://github.com/Kokonut-Original/csattt-ids/issues/7)–[#14](https://github.com/Kokonut-Original/csattt-ids/issues/14), [#16](https://github.com/Kokonut-Original/csattt-ids/issues/16); #11 đóng vì trùng/không làm | Cập nhật acceptance, người phụ trách và bằng chứng; không tự đóng việc chưa review |
| Milestones theo checkpoint | Đạt | [v1.0-midterm](https://github.com/Kokonut-Original/csattt-ids/milestone/1), [v2.0-final](https://github.com/Kokonut-Original/csattt-ids/milestone/2); #14/#16 gắn milestone 2 | Chốt hạn thật và rà việc tồn, không coi milestone là tag |
| Projects Kanban theo dõi tiến độ | Chưa xác minh, chưa tính đạt | Repo có `has_projects: true`; điều đó chỉ bật tính năng, không chứng minh có board/items | Kiểm tra board, đưa Issues vào Todo/In progress/In review/Done; connector hiện không có thao tác Projects |
| Tag v1.0-midterm và v2.0-final | Chưa đạt | API matching refs `tags/` trả `[]` | Long tự tạo đúng commit trên web khi tới checkpoint |
| Release có PDF và video demo | Chưa đạt | API releases trả `[]` | Long tự tạo Release và đính kèm bộ nộp đã rà; chưa tạo trong phiên này |
| GitHub Actions SAST | Đạt cấu hình ở PR; kết quả xem CI | `.github/workflows/quality.yml`, `.semgrep.yml`; Semgrep local chạy 3 rule policy | Đọc [CI mới nhất](https://github.com/Kokonut-Original/csattt-ids/pull/15/checks) trên SHA cuối; policy chỉ kiểm một số rủi ro, không phải audit toàn diện |
| GitHub Actions lint | Đạt cấu hình ở PR; kết quả xem CI | Bash syntax và ShellCheck severity warning đã pass local | Đọc [CI mới nhất](https://github.com/Kokonut-Original/csattt-ids/pull/15/checks) trên SHA cuối |
| GitHub Actions test tự động | Đạt cấu hình ở PR; kết quả xem CI | `tests/compose_smoke.sh`: runner dùng một lần, build/up/benign/read-only mount/persistence sau recreate | Đọc [CI mới nhất](https://github.com/Kokonut-Original/csattt-ids/pull/15/checks); CI không cài/kiểm Wazuh hoặc chạy payload tấn công |
| Không commit secret | Chưa đạt vệ sinh toàn repo; thay đổi mới đã rà | Credential đã đưa ra file local và được đổi sau khi thấy giá trị cũ có trong lịch sử; Gitleaks local quét lịch sử không thấy mẫu leak của bộ rule mặc định | Gitleaks không bắt mọi mật khẩu đơn giản; main vẫn có dữ liệu cũ, cần xử lý #13 và rà lịch sử trước chia sẻ |
| Secret scanning của GitHub bật mặc định | Chưa xác minh, chưa tính đạt | API repo không trả trạng thái Secret Protection; quyền connector không cho đọc cài đặt nhạy cảm | Xác minh khả năng hỗ trợ của repo private cá nhân với thầy. Job Gitleaks là biện pháp bổ sung, không thay thế yêu cầu bật tính năng GitHub |
| Dependabot bật mặc định | Chưa đạt toàn bộ | Đã thêm `.github/dependabot.yml` cho cập nhật GitHub Actions, target develop; chưa merge default branch | Merge qua review; xác minh Dependabot alerts/security updates trong Settings. Có file config chưa chứng minh alerts đã bật |
| Báo cáo PDF 20–40 trang và đủ các mục | Chưa xác minh bộ nộp; chưa có PDF trong các cây repo đã đọc | Cây main/develop hiện chỉ thấy Markdown/evidence, không có report PDF | Đọc bản nhóm đang có, hoàn thiện và đưa bản cuối vào docs/Release; không kết luận nhóm chưa viết ngoài repo |
| Slide 10–15 phút | Chưa xác minh | Không thấy deck trong các cây repo đã đọc | Nhóm bổ sung deck và tổng duyệt; chưa tạo slide trong phạm vi kiểm GitHub |
| Demo 5–10 phút và tái lập | Chưa đạt toàn bộ bộ nộp | Có kiểm chứng năm bài trong [kết quả 13/11](results/lab-reproducibility-2026-11-13.md); video scan/SSH mới là thông tin bàn giao, chưa xem | Kiểm video, thời lượng, phiên bản cấu hình và demo đủ ý; chưa có video đính Release |
| Script/cấu hình được version hóa | Đạt phần container ở PR | Compose/Dockerfile/startup/scripts, [cấu hình host đã đối chiếu](../lab/host-config.md), bằng chứng live | Hướng dẫn cài host Wazuh/Suricata từ đầu và một lượt tái lập độc lập còn thiếu |
| Lab cô lập, không mục tiêu ngoài quyền | Đạt trong khoảng đo; không phải air-gap | Capture toàn br-lab không có IPv4 ngoài subnet và không có IPv6 trong lượt kiểm; đích script cố định | Bridge vẫn có NAT; kiểm phạm vi trước mỗi lượt, chưa chứng minh mọi hoạt động tương lai không ra ngoài |
| Bảng ánh xạ CLO2/CLO3 | Đạt bản nháp ở PR | [ETHICS-CLO](ETHICS-CLO.md) nối công cụ/kết quả/phạm vi với bằng chứng | Đưa mapping vào từng deliverable cuối và nhóm kiểm lại |
| Cam kết đạo đức và tham chiếu pháp lý | Chưa hoàn tất bộ nộp | [ETHICS-CLO](ETHICS-CLO.md) có nội dung dự thảo và danh sách tham chiếu theo đề | Nhóm xác nhận, bổ sung vào báo cáo và đối chiếu văn bản áp dụng; chưa có chữ ký/xác nhận thay thành viên |
| License rõ ràng | Chưa đạt | API repo `license: null`; tài liệu ghi quyền được bảo lưu, không tự cấp license nguồn mở | Nhóm chốt quyền dùng/sửa/phân phối và thông báo license phù hợp; không tự gán MIT cho đóng góp người khác |
| Responsible disclosure qua kênh riêng và giảng viên | Đạt về quy trình dự thảo | [SECURITY](../SECURITY.md) quy định dừng khai thác, báo riêng, không dán secret | Bổ sung kênh/tài khoản giảng viên được nhóm xác nhận; chưa có vụ việc thật cần báo cáo |
| Không public payload và có retention dữ liệu | Chưa hoàn tất chính sách | Repo private, output mới ngoài repo; main còn raw logs/pcap, [#13](https://github.com/Kokonut-Original/csattt-ids/issues/13) đang mở | Rà dữ liệu cũ, chốt thời hạn lưu/xóa; dọn main chỉ bằng PR riêng sau khi xác nhận bản cần giữ |
| Bài 4: FP/FN và tuning | Chưa kết luận hoàn tất | Có kết quả Duy (8.0.6) và smoke test tích hợp (7.0.3), [#9](https://github.com/Kokonut-Original/csattt-ids/issues/9) mở | Chốt đơn vị/mẫu số và đối chiếu phiên bản; không lấy số alert làm số lượt tấn công |
| Bài 4: timeline cảnh báo rồi chặn drop | Đã kiểm chứng DNS trong nhánh IPS; chờ review | [Kết quả IDS–IPS–IDS](results/ips-dns-drop-2026-11-13.md), SID 1000014 blocked ở EVE/Wazuh; #8 còn mở | Review, tái lập độc lập và ghép vào demo cuối; không suy thành chặn mọi kịch bản |

## Giới hạn truy cập và bằng chứng

Branch details đã cho biết protected=false. Endpoint đọc protection chi tiết trả 403 “Resource not accessible by integration”; endpoint rulesets trả thông báo yêu cầu nâng cấp Pro hoặc public. Không suy từ lỗi thiếu quyền rằng mọi setting khác tắt. Không thay đổi gói, ownership, visibility, quyền giảng viên hoặc cài đặt bảo mật.

Chưa xác minh Project board, Secret Protection hoặc Dependabot alerts. Không yêu cầu người dùng gửi token vào chat. GitHub chưa có credential lưu trong clone Ubuntu; nhánh được đẩy qua connector và đối chiếu tree/commit với bản local. Thao tác browser bị dừng vì không xác định URL đủ tin cậy, nên không dùng giao diện để suy đoán Settings.

## Nguồn nền tảng đã đọc ngày 13/11/2026

- [GitHub về branch protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches): private cần gói hỗ trợ; giới hạn này khớp thông báo API trên repo. Không tự mua gói.
- [GitHub về quyền tài khoản](https://docs.github.com/en/get-started/learning-about-github/access-permissions-on-github): repo cá nhân có owner/collaborator; yêu cầu Maintain của đề cần trao đổi với thầy theo mô hình repo phù hợp, không tự chuyển repo.
- [GitHub về secret scanning](https://docs.github.com/en/code-security/how-tos/secure-your-secrets/detect-secret-leaks/enable-secret-scanning): khả năng bật khác nhau theo owner/gói; không gọi Gitleaks là Secret Protection đã bật.
- [Semgrep CE trên CI](https://docs.semgrep.dev/semgrep-ci/sample-ci-configs): dùng local policy/metrics off, không cần tài khoản hoặc token Semgrep; policy nhỏ không bảo đảm phát hiện mọi vấn đề.
- [Gitleaks](https://github.com/gitleaks/gitleaks): quét Git với redact; kết quả không thấy leak là theo bộ rule và lịch sử đã quét, không phủ mọi secret.

## Thứ tự việc còn lại

Hoàn tất các run CI của PR #15 rồi để thành viên khác review trên GitHub. Nhóm xác minh Projects/Settings, license và quyền giảng viên; không biến các mục chưa truy cập thành đạt. Sau review/merge develop mới xem xét PR dọn main #13. Tiếp tục IPS/drop và đối chiếu FP/FN ở task riêng. Long tự tạo Tag/Release sau khi bộ báo cáo/slide/video được kiểm.

CI lượt đầu trên commit 9615348 đã pass Semgrep/lint/secret scan nhưng integration lỗi khi thư mục log mới trống. Đã tái hiện Apache thiếu `/var/log/apache2` trong container tạm; startup được sửa để tạo thư mục và test CI được bổ sung log chẩn đoán khi lỗi. Trạng thái run sau sửa xem tab Checks của PR; không lấy run thất bại làm bằng chứng dựng mới thành công.
