# FTP Server with vsftpd and Docker Compose

This project provides a simple FTP server setup using `vsftpd` in a Docker container, with a mounted volume for synchronizing files between the container and the host system. The configuration is managed via `docker-compose` for easy deployment and management.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Ievhen/docker-ftp-sync.git
   cd docker-ftp-sync
   ```

2. Create a directory on the host system to sync with the container:
   ```bash
   mkdir ./ftp_data
   ```

3. Create a .env file in the project root to configure server parameters, such as timezone, passive address for vsftpd, and FTP user password. Example .env file:
    ```ini
    TZ=Europe/Warsaw
    PASV_ADDRESS=172.31.176.1
    FTP_USER_PASSWORD=ftp
    ```

4. (Optional) Modify the `docker-compose.yml` file to customize settings, such as:
   - Port mappings
   - Volume paths, if a folder other than the default `./ftp_data` is used.

5. Start the FTP server:
   ```bash
   docker-compose up -d
   ```

# Additional Configuration
For all available options in the `vsftpd.conf` configuration file, refer to the official vsftpd [documentation](http://vsftpd.beasts.org/vsftpd_conf.html).

# Project Structure
```bash
.
├── .env  # Create .env file using .env.template
├── .env.template
├── Dockerfile
├── README.md
├── config
│   └── vsftpd.conf.template 
├── docker-compose.yml
├── ftp_data  # Create host directory for file synchronization
└── scripts
    └── docker-entrypoint.sh
```