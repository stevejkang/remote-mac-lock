import express from 'express';

class ExecuteScreenLock {
  public path = '/';
  public router = express.Router();

  constructor() {
    this.router.get(this.path, this.execute);
  }

  execute = async (request: express.Request, response: express.Response) => {
    await this.execShellCommand(`./lockscreen`);
    response.status(200).json({ ok: true });
  }

  execShellCommand = (cmd: string) => {
    const exec = require('child_process').exec;
    return new Promise((resolve, reject) => {
      exec(cmd, (error: any, stdout: any, stderr: any) => {
        if (error) console.warn(error);
        resolve(stdout? stdout : stderr);
      });
    });
  }
}

export default ExecuteScreenLock;
