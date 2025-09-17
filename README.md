# Automatic Database Backup Script

Automated script for MariaDB/MySQL database backup with upload to Amazon S3.

## 📋 Description

This script performs automatic backup of a database running in a Docker and uploads the compressed file to an AWS S3 bucket.

## 🔧 Prerequisites

- Docker with MariaDB/MySQL container running
- AWS CLI installed
- Valid AWS credentials
- Credentials of database

## 📦 Dependencies

- `docker`
- `gzip`
- `aws-cli`

## ⚙️ Configuration

### 1. Configure script variables

Edit the `automatic-bkp.sh` file and adjust the following variables:

```bash
BUCKET_NAME='your-bucket-name'
DESTINATION_IN_BUCKET='backups/'
AWS_ACCESS_KEY_ID="your-access-key"
AWS_SECRET_ACCESS_KEY="your-secret-key"
AWS_DEFAULT_REGION="us-east-1"
```

### 2. Configure Docker container

Make sure the MariaDB container is running with the name `mariadb`:

```bash
docker ps | grep mariadb
```

### 3. Permissions

Give execution permission to the script:

```bash
chmod +x automatic-bkp.sh
```

## Usage

### Manual execution

```bash
./automatic-bkp.sh
```

Or

```bash
source automatic-bkp.sh
```

### Scheduling with cron

Examples crontab:

```bash
# Daily backup at 2:00 AM
0 2 * * * /path/to/automatic-bkp.sh

# Backup every 6 hours
0 */6 * * * /path/to/automatic-bkp.sh
```

## 📁 File structure

```
Machine:
/tmp/
└── backup-auto-DD-MM-YYYY-HHh.sql.gz

S3 Bucket:
└── backups/
    └── backup-auto-DD-MM-YYYY-HHh.sql.gz
```

## 🔄 How it works

1. **Filename generation**: Creates unique name based on current date/time
2. **Database backup**: Executes `mysqldump` in Docker container
3. **Compression**: Compresses dump using `gzip`
4. **S3 upload**: Sends file to configured bucket
5. **Verification**: Confirms if upload was successful

## 📝 Backup filename format

```
backup-auto-16-09-2025-14h.sql.gz
```

- `DD-MM-YYYY`: Current date
- `HHh`: Current hour

## 🐛 Troubleshooting

### Error: "Unable to locate credentials"
- Check if AWS credentials are correct
- Make sure variables are exported

### Error: "Container not found"
- Check if MariaDB container is running
- Confirm container name

### Error: "Access Denied S3"
- Check S3 bucket permissions
- Confirm credentials have bucket access


## Results

<img width="1114" height="341" alt="Screenshot_20250916_212937" src="https://github.com/user-attachments/assets/991392e0-579e-40bf-afdd-3a66bb9704d8" />
