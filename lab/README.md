# Lab Suricata và Wazuh

Lab BTL SEC1304 gồm victim `172.28.0.10`, Kali `172.28.0.20`, server3 `172.28.0.30`; bridge `br-lab`, subnet `172.28.0.0/24`. Chỉ chạy các script vào các địa chỉ này. Suricata và Wazuh cài trên Ubuntu host; Compose không sửa cấu hình hai dịch vụ đó.

## Chuẩn bị lần đầu

Cần Docker Engine và Compose v2 hỗ trợ thuộc tính `name`, `build` và secrets từ file. Chạy từ gốc repo. Chuẩn bị file bí mật ngoài repo bằng nhập tương tác, không ghi mật khẩu vào lệnh hoặc commit:

```bash
export LAB_STATE_DIR="$HOME/lab"
mkdir -p "$LAB_STATE_DIR/secrets" "$LAB_STATE_DIR/pcap"
chmod 700 "$LAB_STATE_DIR/secrets"
umask 077
read -rsp 'Victim lab password: ' LAB_PASSWORD; printf '\n'
printf '%s\n' "$LAB_PASSWORD" > "$LAB_STATE_DIR/secrets/victim_password"
unset LAB_PASSWORD
read -rsp 'Server3 lab password: ' LAB_PASSWORD; printf '\n'
printf '%s\n' "$LAB_PASSWORD" > "$LAB_STATE_DIR/secrets/server3_password"
unset LAB_PASSWORD
docker compose -f lab/docker-compose.yml config --quiet
docker compose -f lab/docker-compose.yml build
docker compose -f lab/docker-compose.yml up -d --wait --wait-timeout 90
docker compose -f lab/docker-compose.yml ps
```

Mật khẩu phải là một dòng, không chứa dấu hai chấm và không trùng bất kỳ dòng nào trong `lab/fixtures/ssh-wrong-guesses.txt`. Tài khoản victim là `testuser`, server3 là `testuser2`. Fixture chỉ chứa 10 giá trị giả sai để Hydra không dừng vì đoán đúng sớm.

Các gói được cài lúc build, không cài lại khi khởi động container. Victim tự bật SSH, Apache, rsyslog và DNS nội bộ `exfil.lab`. DNS không dùng upstream; NXDOMAIN cho TXT giả là kết quả mong đợi. Server3 chạy SSH/rsyslog. Tất cả dùng `Asia/Ho_Chi_Minh`; bằng chứng cần ghi thêm thời gian UTC để ghép với log host.

| Dữ liệu | Trên host | Trong container |
|---|---|---|
| Script | `scripts/` trong repo | `/root/scripts`, chỉ đọc trên Kali/victim |
| Pcap và output thử nghiệm | `$LAB_STATE_DIR/pcap` | `/root/pcap`, Kali/victim |
| Log victim | `$LAB_STATE_DIR/logs/victim` | `/var/log` ở victim, `/root/logs/victim` chỉ đọc ở Kali |
| Log server3 | `$LAB_STATE_DIR/logs/server3` | `/var/log` ở server3 |
| Bí mật | `$LAB_STATE_DIR/secrets` | chỉ mount mật khẩu của từng máy vào `/run/secrets/lab_password` |

Các cổng host chỉ bind loopback: victim `2222→22`, `8080→80`; server3 `2223→22`. Đây là cổng trên Ubuntu, khác cổng SSH NAT VirtualBox trên Windows. Không bật Wazuh Active Response hay thay agent Windows.

## Chạy lại năm kịch bản

```bash
docker exec kali bash /root/scripts/01_port_scan.sh
docker exec kali bash /root/scripts/02_ssh_bruteforce.sh
docker exec kali bash /root/scripts/03_icmp_flood.sh
docker exec kali bash /root/scripts/04_dns_tunnel_sim.sh
# Terminal thứ nhất: mở listener có bắt pcap trong Kali
docker exec -it kali bash /root/scripts/05_reverse_shell.sh attacker
# Terminal thứ hai: chạy đúng bên trong victim
docker exec -it victim bash /root/scripts/05_reverse_shell.sh victim
# Gõ exit trong phiên thử nghiệm để kết thúc, không để listener/shell chạy nền.
```

Script luôn dùng đích cố định trong lab. Nmap dùng `-n` để không tra DNS ngoài. Capture được đặt đúng eth0 và chỉ giữ lưu lượng lab tương ứng; dùng capture toàn bridge riêng khi kiểm tra rò lưu lượng. Giữ hành vi tạo lưu lượng của script cũ; capture được đóng khi hoàn tất hoặc bị ngắt, pcap có timestamp và lưu ngoài repo.

Trước lượt attack, chạy `bash tests/normal_traffic.sh` khi các cửa sổ đếm trước đã hết (ít nhất 65 giây sau lượt attack trước). Không xóa fast.log/eve.json/alerts.json. Ghi offset/thời gian đầu-cuối mỗi lượt và đối chiếu SID tương ứng `1000001–1000005` ở cả EVE và Wazuh. Một lượt thấy cảnh báo chỉ chứng minh đường chạy đó, không chứng minh rule tổng quát hoặc không báo nhầm.

Rule scan đếm SYN, SSH đếm kết nối chứ không đếm mật khẩu; DNS đếm mật độ truy vấn; reverse shell dựa SYN-ACK cổng 4444. Đây là các giới hạn của bài mô phỏng. Bộ rule hiện là IDS `alert`; IPS/drop là hạng mục khác, chưa hoàn thành bằng việc dựng lại Compose.

## Chuyển từ lab đang chạy và rollback

Không chạy `down` hoặc ghi đè Compose cũ trước khi sao lưu. Kiểm tra Compose project/config labels và mounts bằng `docker inspect` (nội dung có thể chứa bí mật, không đưa toàn bộ output lên GitHub). Lưu ngoài repo: Compose cũ, file thay đổi trong `/root` và `/tmp`, host log/pcap, danh sách gói, metadata container/network, image snapshot cục bộ từng container và SHA256. Kiểm hash trước chuyển đổi.

Project dùng tên `lab`, network `lab_lab_net` và bridge `br-lab`. Trên lab hiện có, dùng đúng project đó và `up -d --no-deps --wait` để thay từng service; không xóa network đang được Suricata nghe. Kiểm tra network ID và hash cấu hình Suricata/Wazuh trước/sau. Nếu network hiện có thuộc project khác, dừng để đối chiếu thay vì tạo bridge trùng.

Rollback: dùng các image snapshot và Compose cũ trong thư mục backup; tạo override chỉ thay `image` và bỏ `command`/`entrypoint` mới nếu có. Khôi phục từng service bằng project `lab` trên network cũ. Dữ liệu bind mount được giữ riêng; chỉ khôi phục file đã biết từ bản backup, không chép đè log mới hoặc chạy lệnh xóa hàng loạt. Không đẩy image snapshot hay bản backup lên GitHub.

## Giới hạn tái lập và mạng

Image nền Ubuntu/Kali và kho apt có thể thay đổi theo thời gian; lưu image ID, danh sách phiên bản gói và bằng chứng build của lượt kiểm tra. Đây chưa phải build bit-for-bit có pin toàn bộ apt snapshot.

Build cần truy cập kho gói. Bridge hiện tại có NAT, không phải mạng air-gap; chỉ bind loopback không tự chặn container đi Internet. Khi chạy mô phỏng, dùng IP lab cố định và DNS không upstream, capture toàn bridge để kiểm tra có lưu lượng IP ra ngoài subnet hay không. Không tuyên bố cô lập tuyệt đối từ một lần capture. Không đổi mạng Windows/NEXUS để phục vụ BTL.

Trên laptop tích hợp, `/home/student/lab/docker-compose.yml` hiện chỉ include file Compose trong repo với project_directory đúng và env_file cục bộ. Model đã đối chiếu bằng nhau; tránh sửa riêng entrypoint này thành một cấu hình thứ hai. Compose cũ có credential đã được giữ trong backup ngoài repo; hai mật khẩu test hiện tại đã đổi và chỉ nằm ở thư mục secrets cục bộ. Image không chứa SSH host key: key được tạo riêng khi khởi động container.
