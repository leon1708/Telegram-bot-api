# Telegram bot api
This bot require the following package:
```prl
use JSON::Parse;
```
## Simple bot to interact

This is a simple telegram bot using api created in perl, it uses **curl** by system calls and processes the messages section from json response to perform actions.

* This bot supports command execution **exec**. Commands run inside the host server (usefull for admins). Supports error notification.
* Possesses a blocking user feature in groups (ban and chat history delete).
* Provides a warning privacy message for non authorized users on direct messages (can be improved to avoid spam).

## Current commands

* **show time** : returns the current date and time
* **show date** : same as _show date_
* **show epoch** : returns the current epoch in seconds (time of the server).
* **show banned** : lists the banned users (currently keeps banned users during bot process running, this can be improved by using a DB for permanent data). This feature requires **admin privileges** and **Group Privacy** off.
* **exec command** : returns the result of _command_ argument (return error if any typo or argument is wrong).
* **kill bot** : Bot say "Good bye" and bot process on server stops (can be improved to allow it only from admins).
