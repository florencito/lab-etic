# Evidence Collection

📸 **Attack evidence and documentation**

## Directory Structure:

### `before-hardening/`
**Evidence from vulnerable server attacks**
- Successful attack executions
- System compromise demonstrations  
- IDS detection results (baseline)
- Network traffic captures
- Server response analysis

**File naming**: `YYYY-MM-DD_[attack-type]_[evidence-type].[ext]`

Examples:
- `2025-08-13_keylogger_execution-success.png`
- `2025-08-13_dos_server-downtime.png`
- `2025-08-13_malware_infection-proof.png`

### `after-hardening/`
**Evidence from hardened server testing**
- Failed/blocked attack attempts
- Security measure effectiveness
- IDS enhanced detection
- Firewall blocking actions
- Improved server resilience

**File naming**: `YYYY-MM-DD_[attack-type]_blocked_[evidence-type].[ext]`

Examples:
- `2025-08-14_keylogger_blocked_firewall.png`
- `2025-08-14_dos_mitigated_server-stable.png`
- `2025-08-14_malware_blocked_upload-denied.png`

### `ids-detection/`
**IDS monitoring and alerts**
- Snort alert screenshots
- Detection rule effectiveness
- Real-time monitoring captures
- Log analysis results
- Alert correlation analysis

**File naming**: `YYYY-MM-DD_ids_[attack-type]_[detection-result].[ext]`

Examples:
- `2025-08-13_ids_command-injection_detected.png`
- `2025-08-13_ids_dos_high-alerts.png`
- `2025-08-13_ids_malware_signature-match.png`

## Collection Guidelines:

### Required Screenshots:
1. **Attack Execution**: Command/tool running
2. **System Impact**: Resource usage, errors, downtime
3. **IDS Alerts**: Real-time detection evidence
4. **Comparison**: Before vs after hardening results

### Best Practices:
- Include timestamps in screenshots
- Capture full terminal/browser windows
- Document command parameters used
- Save both success and failure evidence
- Maintain chronological organization

### Academic Requirements:
- Evidence must support written report
- Screenshots should be high quality and readable
- Include context information in file names
- Organize by task completion sequence
