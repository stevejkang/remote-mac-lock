# remote-mac-lock

### Installation
> This instruction is only available in macOS.
> Also, make sure that all devices are connected to the same wireless access point.
```bash
git clone https://github.com/stevejkang/remote-mac-lock && cd remote-mac-lock
cp .env.example .env # set your own credentials for authentication
yarn
yarn start
```
And then, visit `https://<your-local-ip>:3000/` (For example, `http://192.168.0.121:3000/`)
