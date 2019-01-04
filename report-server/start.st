(MeEasy readFromStonFileAt: Menta repositoryPath / 'MeDemoApp.ston') start.

"VNC support"

UIManager default: NonInteractiveUIManager new.

Workspace openContents: '
UIManager default: MorphicUIManager new.
UIManager default: NonInteractiveUIManager new.
'.

RFBServer current
    initializePreferences;
    allowEmptyPasswords: false;
    setFullPassword: 'secret';
    setViewPassword: 'secret';
    enableLogging: true;
    enableDebugging: true;
    start: 0.
