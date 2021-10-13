import App from './App';
import ExecuteScreenLock from './controller/ExecuteScreenLock';
 
const app = new App(
  [
    new ExecuteScreenLock(),
  ]
);
 
app.listen();
