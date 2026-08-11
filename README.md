# remote-mac-lock

### Usage
> This instruction is only available in macOS.
> Also, make sure that all devices are connected to the same network.
```bash
git clone https://github.com/stevejkang/remote-mac-lock && cd remote-mac-lock
cp .env.example .env # set your own credentials for basic authentication
make
docker build -t remote-mac-lock .
docker run -d --env-file .env -v $(pwd)/lockscreen:/app/lockscreen -p 3000:3000 remote-mac-lock
```
And then, visit `http://<your-local-ip>:3000/lock`
