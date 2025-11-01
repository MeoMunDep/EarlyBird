@echo off
title Earlybird Bot by @MeoMunDep
color 0A

cd %~dp0

echo Checking for bot updates...
git pull origin main > nul 2>&1
echo Bot updated!

echo Checking configuration files...

if not exist configs.json (
    (
        echo {
        echo   "proxyMode": "static",
        echo   "skipInvalidProxy": false,
        echo   "delayEachAccount": [1, 1],
        echo   "timeToRestartAllAccounts": 86400,
        echo   "howManyAccountsRunInOneTime": 1,
        echo,
        echo   "redeemTokens": false,
        echo   "closePositions": true,
        echo,
        echo   "tradeLongShort": {
        echo     "enabled": true,
        echo     "amountUSD": [5, 15]
        echo   },
        echo,
        echo   "captcha": {
        echo     "provider": "2captcha",
        echo     "providers": {
        echo       "2captcha": { "apiKey": "YOUR_2CAPTCHA_KEY" },
        echo       "anticaptcha": { "apiKey": "YOUR_ANTICAPTCHA_KEY" }
        echo     }
        echo   },
        echo,
        echo   "proxy": {
        echo     "useProxies": true
        echo   }
        echo }
    )> configs.json
    echo configs.json created successfully!
)



(for %%F in (privateKeys.txt proxies.txt) do (
    if not exist %%F (
        type nul > %%F
        echo Created %%F
    )
))

echo Configuration files checked.

echo Checking dependencies...
if exist "..\node_modules" (
    echo Using node_modules from parent directory...
    cd ..
    CALL npm install user-agents axios meo-forkcy-colors meo-forkcy-utils meo-forkcy-proxy meo-forkcy-logger @solana/web3.js @solana/spl-token bs58
    cd %~dp0
) else (
    echo Installing dependencies in current directory...
    CALL npm install user-agents axios meo-forkcy-colors meo-forkcy-utils meo-forkcy-proxy meo-forkcy-logger @solana/web3.js @solana/spl-token bs58
)
echo Dependencies installation completed!

echo Starting the bot...
node meomundep

pause
exit
