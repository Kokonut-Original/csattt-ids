# Script kiểm thử rule Suricata
Yêu cầu: lab đang chạy (`docker-compose up -d`), Suricata nghe `br-lab`, ghi log vào `~/lab/log`.

| Script | Kiểm tra |
|---|---|
| `bash tests/normal_traffic.sh` | Lưu lượng bình thường không bị báo nhầm (FP) |
| `bash tests/replay_pcap.sh [thư-mục-pcap]` | Chạy lại 5 pcap tấn công |
| `bash tests/icmp_flood_live.sh normal\|attack` | ICMP flood live 2 chiều |
| `bash tests/dns_tunnel_live.sh` | DNS tunnel live |
