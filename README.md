# Chat on Rails

## Install
```bash
git clone git@github.com:KhaledR57/Chat-On-Rails.git
cd Chat-On-Rails
docker compose up
```

## Ruby version
- ruby 3.0.2

## Gems
- mysql2
- redis
- elasticsearch-model
- elasticsearch-rails
- sidekiq
- kaminari
- rufus-scheduler

## API Endpoints
| Action                                                                           | Method | Path                                                                                        |
|----------------------------------------------------------------------------------|--------|---------------------------------------------------------------------------------------------|
| **Applicaion**                                                                                                                                                                          |
| Create new application                                                           | POST   | /applications                                                                               |
| Get an application                                                               | GET    | /applications/<application_token>                                                           |
| All applications                                                                 | GET    | /applications                                                                               |
| Update Application                                                               | PUT    | /applications/<application_token>                                                           |
| Delete Application                                                               | DELETE | /applications/<application_token>                                                           |
| **Chat**                                                                                                                                                                                |
| Create Chat                                                                      | POST   | /applications/<application_token>/chats                                                     |
| Get Chat                                                                         | GET    | /applications/<application_token>/chats/<chat_number>                                       |
| All chats that belong to a specific application (with pagination)                | GET    | /applications/X1tXyNcwy_ntFXMSFnp4FA/chats?page=<page_number>                               |
| Delete Chat                                                                      | DELETE | /applications/<application_token>/chats/<chat_number>                                       |
| **Message**                                                                                                                                                                             |
| Create Message                                                                   | POST   | /applications/<application_token>/chats/<chat_number>/messages                              |
| Searching through messages of a specific chat (partially match messages’ bodies) | GET    | /applications/<application_token>/chats/<chat_number>/messages/search?query=<message_query> |
| Get all messages that belong to a specific chat (with pagination)                | GET    | /applications/<application_token>/chats/<chat_number>/messages?page=<page_number>           |
| Update Message                                                                   | PUT    | /applications/<application_token>/chats/<chat_number>/messages/<message_number>             |
| Delete Message                                                                   | DELETE | /applications/<application_token>/chats/<chat_number>/messages/<message_number>             |

