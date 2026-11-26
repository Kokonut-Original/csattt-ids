"""Regression checks for rollback comparisons; never execute firewall commands."""
from pathlib import Path
import subprocess
import sys
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "scripts/ips_firewall_canonical.py"


def canonical(text):
    return subprocess.run(
        [sys.executable, str(SCRIPT)], input=text, text=True,
        capture_output=True, check=True,
    ).stdout


class FirewallRollbackComparison(unittest.TestCase):
    def test_counters_do_not_mask_a_restored_rule(self):
        first = "*filter\n:INPUT ACCEPT [2:60]\n-A INPUT -p udp -j ACCEPT\nCOMMIT\n"
        later = first.replace("[2:60]", "[19:822]")
        self.assertEqual(canonical(first), canonical(later))

    def test_empty_accept_filter_is_inert(self):
        empty = "*filter\n:INPUT ACCEPT [0:0]\n:FORWARD ACCEPT [0:0]\n:OUTPUT ACCEPT [0:0]\nCOMMIT\n"
        self.assertEqual(canonical(""), canonical(empty))

    def test_drop_policy_must_not_disappear(self):
        policy = "*filter\n:INPUT DROP [1:60]\nCOMMIT\n"
        self.assertNotEqual(canonical(""), canonical(policy))
        self.assertIn("DROP", canonical(policy))

    def test_leftover_queue_hook_is_visible(self):
        hook = "*filter\n:INPUT ACCEPT [0:0]\n-A INPUT -p udp -j NFQUEUE --queue-num 100\nCOMMIT\n"
        self.assertNotEqual(canonical(""), canonical(hook))
        self.assertIn("NFQUEUE", canonical(hook))

    def test_rule_order_and_user_chains_are_preserved(self):
        first = "*filter\n:INPUT ACCEPT [0:0]\n:USER - [0:0]\n-A INPUT -p udp -j ACCEPT\n-A INPUT -j DROP\nCOMMIT\n"
        reversed_rules = first.replace("-A INPUT -p udp -j ACCEPT\n-A INPUT -j DROP", "-A INPUT -j DROP\n-A INPUT -p udp -j ACCEPT")
        self.assertIn(":USER -", canonical(first))
        self.assertNotEqual(canonical(first), canonical(reversed_rules))

    def test_incomplete_snapshot_is_rejected(self):
        with self.assertRaises(subprocess.CalledProcessError):
            canonical("*filter\n:INPUT ACCEPT [0:0]\n")


if __name__ == "__main__":
    unittest.main()
