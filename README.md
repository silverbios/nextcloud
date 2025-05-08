# Nextcloud Docker Image (Multi-Arch with SMB, Cron, and Notify_Push)

A custom, multi-architecture Docker image for [Nextcloud](https://nextcloud.com/), optimized for real-world deployments. This image includes built-in support for SMB external storage, scheduled background jobs via cron, and provides a separate image for `notify_push` to enable real-time updates.

## 🔥 Key Features

- ✅ **Multi-Architecture Support**: Works on `amd64`, `arm64`, etc.
- 📁 **SMB External Storage**: Ready to mount and use SMB shares out of the box.
- ⏱️ **Built-in Cron**: No need for external schedulers—cron is handled internally.
- 🔔 **Separate `notify_push` Image**: Production-grade support for real-time file change notifications.
- 🐳 **Supervisor-based Process Management**: Manages background services cleanly.

## 🗂️ Repository Contents

- `NextCloud.Dockerfile`: Builds the main Nextcloud image with cron and SMB support.
- `Notify_Push.Dockerfile`: Builds a minimal image containing only the `notify_push` binary.
- `supervisord.conf`: Runs Apache and cron processes within the same container.
- `.github/workflows/`: GitHub Actions workflow to build and optionally push images.
- `.gitignore`: Standard exclusions for version control hygiene.

---

## 🚀 Usage

### 🔨 Build the Nextcloud Image

```bash
docker build -f NextCloud.Dockerfile -t my-nextcloud .

docker run -d \
  --name nextcloud \
  -p 8080:80 \
  -v nextcloud_data:/var/www/html \
  my-nextcloud
```
Access via http://localhost:8080

ℹ️ External SMB storage can be added via Nextcloud’s admin settings under External Storage.

# 🔔 Notify_Push
The repository also includes a lightweight image specifically for notify_push.

##Build notify_push Image
```bash
docker build -f Notify_Push.Dockerfile -t my-notify_push .
```
