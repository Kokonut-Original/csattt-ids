"""Compare firewall rules/policies, ignoring counters and inert empty filter scaffolding."""
import re
import sys

text = re.sub(r"\[\d+:\d+\]", "[0:0]", sys.stdin.read())
lines = [line for line in text.splitlines() if line and not line.startswith("#")]
block = []
for line in lines:
    block.append(line)
    if line == "COMMIT":
        inert_filter = block[0] == "*filter" and all(
            re.fullmatch(r":(?:INPUT|FORWARD|OUTPUT) ACCEPT \[0:0\]", item)
            for item in block[1:-1]
        )
        if not inert_filter:
            print("\n".join(block))
        block = []
if block:
    raise SystemExit("Incomplete iptables-save block")
