import express, { Application, Router } from 'express';
import basicAuth from 'express-basic-auth';
import dotenv from 'dotenv';

dotenv.config();

export interface Controller {
  path: string;
  router: Router;
}

interface AppConfig {
  port?: number;
}

class App {
  public readonly app: Application;
  public readonly port: number;

  constructor(controllers: Controller[], config: AppConfig = {}) {
    this.app = express();
    this.port = config.port ?? 3000;

    this.initializeAuth();
    this.initializeMiddlewares();
    this.initializeControllers(controllers);
  }

  private initializeAuth(): void {
    const user = process.env.BASIC_AUTH_USER;
    const pass = process.env.BASIC_AUTH_PASS;

    if (!user || !pass) {
      throw new Error('BASIC_AUTH_USER and BASIC_AUTH_PASS must be set in environment variables');
    }

    this.app.use(
      '/',
      basicAuth({
        challenge: true,
        users: { [user]: pass },
      })
    );
  }

  private initializeMiddlewares(): void {
    this.app.use(express.json());
  }

  private initializeControllers(controllers: Controller[]): void {
    controllers.forEach((controller) => {
      this.app.use(controller.path, controller.router);
    });
  }

  public listen(): void {
    this.app.listen(this.port, () => {
      console.log(`App listening on port ${this.port}`);
    });
  }
}

export default App;
