import express from 'express';
import basicAuth from 'express-basic-auth';
import * as dotenv from 'dotenv';
dotenv.config();
class App {
  public app: express.Application;
  public port: number;

  constructor(controllers: any, port: number = 3000) {
    this.app = express();
    this.port = port;

    this.app.use('/', basicAuth({
      challenge: true,
      users: { [`${process.env.BASIC_AUTH_USER}`]: `${process.env.BASIC_AUTH_PASS}` },
    }));

    this.initializeMiddlewares();
    this.initializeControllers(controllers);
  }

  private initializeMiddlewares() {
    this.app.use(express.json());
  }

  private initializeControllers(controllers: any[]) {
    controllers.forEach((controller) => {
      this.app.use('/', controller.router);
    });
  }

  public listen() {
    this.app.listen(this.port, () => {
      console.log(`App listening on the port ${this.port}`);
    });
  }
}

export default App;
