UIManager default: NonInteractiveUIManager new.
(MeEasy readFromStonFileAt: Menta repositoryPath / 'MeDemoApp.ston') start.
RFBServer current
    initializePreferences;
    allowEmptyPasswords: false;
    setFullPassword: 'secret';
    setViewPassword: 'secret';
    enableLogging: true;
    enableDebugging: true;
    start: 0.
