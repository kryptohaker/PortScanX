## PortScanX

PortScanX is a Python script that automates the process of scanning ports on multiple targets using `masscan` and performing additional `nmap` scans if open ports are found. It provides a streamlined approach to efficiently scan ports and gather information about targeted systems.

### Features

- **Parallel Processing**: PortScanX utilizes a multi-threaded approach with `ThreadPoolExecutor` to process multiple targets simultaneously, saving time during the scanning process.
- **Masscan Integration**: PortScanX integrates with `masscan`, a fast port scanner, to scan for open ports on the specified targets. It saves the results to a file for further analysis.
- **Nmap Scans**: If open ports are found during the masscan, PortScanX performs additional detailed scans using `nmap`, a powerful network exploration and security auditing tool. These scans provide more comprehensive information about the discovered open ports.
- **Target File Support**: PortScanX accepts a target file as input, allowing you to specify a list of targets in the format `hostname:ip_address`. This flexibility enables scanning multiple targets in a single execution.
- **Flexible Configuration**: You can configure various parameters within the script, such as the rate of the masscan, to suit your scanning requirements.

### Requirements

To use PortScanX, the following dependencies need to be installed on your system:

- `Python 3`
- `masscan`
- `nmap`
- `awk`
- `sed`
- `tr`

### Usage

1. Clone this repository: `git clone https://github.com/your_username/PortScanX.git`
2. Navigate to the project directory: `cd PortScanX`
3. Install the required dependencies, if not already installed.
4. Prepare a target file with the list of targets in the format `hostname:ip_address`.
5. Run the script with the following command:

```bash
python3 portscanx.py -t <target_file> -e <interface>
```

6. Replace `<target_file>` with the path to your target file, and `<interface>` with the desired interface for masscan.
7. Sit back and let PortScanX perform the port scans on the specified targets. The script will create folders for each target and save the scan results in the respective folders.

### Disclaimer

Please note that port scanning without proper authorization is often against the terms of service of network providers and may be illegal in certain jurisdictions. Ensure that you have proper authorization and adhere to legal and ethical guidelines before using this tool.
