import { Router, Request, Response } from 'express';
import { exec } from 'node:child_process';
import { promisify } from 'node:util';
import type { Controller } from '../App.js';

const execAsync = promisify(exec);

class ExecuteScreenLock implements Controller {
  public readonly path = '/';
  public readonly router = Router();

  constructor() {
    this.router.get('/', this.execute);
  }

  private execute = async (_req: Request, res: Response): Promise<void> => {
    try {
      await execAsync('./lockscreen');
      res.status(200).json({ ok: true });
    } catch (error) {
      console.error('Failed to execute lockscreen:', error);
      res.status(500).json({ ok: false, error: 'Failed to lock screen' });
    }
  };
}

export default ExecuteScreenLock;
