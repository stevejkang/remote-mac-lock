import App from './App.js';
import ExecuteScreenLock from './controller/ExecuteScreenLock.js';

const app = new App([new ExecuteScreenLock()]);

app.listen();
