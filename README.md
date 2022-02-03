# Telegram bot api

```prl
use JSON::Parse;
```
## Simple bot to interact

This is a simple telegram bot using api created in perl, it uses **curl** by system calls and processes the messages section from json response to perform actions.

* This bot supports command execution **exec** that are sent to the host server (usefull for admins).
* Posseses a blocking user feature in groups (ban and chat history delete).
* Provides a warning privacy message for non authorized users on direct messages (can be improved to avoid spam).
