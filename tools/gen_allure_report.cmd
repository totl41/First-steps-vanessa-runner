@chcp 65001

rem "Если нужна история"
rem "для syntaxCheck"
robocopy .\out\html_report\history\ .\out\syntaxCheck\allure\history
call allure generate --clean .\out\syntaxCheck\allure -o .\out\html_report

robocopy .\out\html_report\history\ .\out\smoke\history
call allure generate --clean .\out\smoke\ -o .\out\html_report
call allure open .\out\html_report

rem call docker-compose up && docker-compose rm -fs
rem "Для PowerShell: allure generate --clean .\out\allure -o .\out\allure\allure-report; allure open .\out\allure\allure-report"