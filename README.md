# OpenStack Administration Scripts

# 🚀 OpenStack Administration Scripts

A collection of useful Bash scripts for OpenStack cloud administrators to simplify common tasks and improve visibility into your cloud infrastructure.

## 🛠️ Scripts Overview

| Script | Description | Usage |
|--------|-------------|-------|
| **list-public-ips.sh** | Lists all public IP addresses in the OpenStack environment, including servers, floating IPs, and router gateways | `./list-public-ips.sh` |
| **instance-report.sh** | Generates a detailed report of all instances with resource usage | `./instance-report.sh [--project PROJECT]` |
| **cleanup-resources.sh** | Identifies and optionally removes orphaned resources | `./cleanup-resources.sh [--delete]` |

## 📋 Detailed Description

### list-public-ips.sh

This script provides a comprehensive overview of all public IP addresses in your OpenStack environment, helping you audit external network exposure.

**Features:**
- Lists all public IPs from servers, floating IPs, and router gateways
- Filters out private IP ranges (10.x.x.x, 172.16-31.x.x, 192.168.x.x)
- Filters out link-local addresses (169.254.x.x)
- Displays resource type and name for easy identification
- Results are sorted by IP address for better readability

**Output format:**
```
IP Address | Resource Type | Name
```

**Requirements:**
- OpenStack CLI tools installed
- Valid OpenStack credentials loaded in your environment

**Example usage:**
```bash
# Simple execution
./list-public-ips.sh

# Save output to a file
./list-public-ips.sh > public-ips.txt
```

## 🚀 Getting Started

### Prerequisites

- OpenStack CLI tools installed
- Valid OpenStack RC file sourced in your shell session

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/openstack-scripts.git
   cd openstack-scripts
   ```

2. Make scripts executable:
   ```bash
   chmod +x *.sh
   ```

3. Source your OpenStack credentials:
   ```bash
   source openrc.sh
   ```

4. Run any script:
   ```bash
   ./list-public-ips.sh
   ```

## 🔒 Security Notes

- These scripts require appropriate OpenStack permissions
- Review output before sharing as it may contain sensitive network information
- Consider securing the output files appropriately

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📬 Contact

Stephan Reugels <s.reugels@netmountains.de>
