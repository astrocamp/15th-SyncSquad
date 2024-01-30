# SyncSquad 同步小隊

► [Visit the website](https://www.syncsquad.online/en)｜[瀏覽網站](https://www.syncsquad.online/tw)

SyncSquad is designed to make project collaboration easy and efficient for teams of businesses. With a user-friendly design and practical features, our aim is to help you manage projects effortlessly, improve team efficiency, and achieve successful project outcomes.

SyncSquad 為團隊及企業提供友善的操作體驗，以及高效率的協作環境，協助您輕鬆管理專案、提升團隊效能，順利實現專案理想成果。

<img width="250" alt="image" src="https://github.com/astrocamp/15th-SyncSquad/assets/136299906/92b15359-2bab-4bb6-960c-1f1980ddd360">

![image](https://github.com/astrocamp/15th-SyncSquad/assets/136299906/8be375cc-326f-4ef7-9c1a-2092d6792f44)

► [Demo video | 展示影片](https://www.youtube.com/watch?v=fhR7VEXZubE)
[![影片示範](https://img.youtube.com/vi/fhR7VEXZubE/0.jpg)](https://www.youtube.com/watch?v=fhR7VEXZubE)

## Features ── 特色功能

### 1. CSV Import CSV 匯入

Our website has two types of members: company accounts and employee accounts. The ability to manage employee data is granted exclusively to company accounts and employee accounts with the role of "HR". In addition to creating individual employee profiles, multiple employee accounts can be efficiently established by importing a CSV file. We use Sidekiq for asynchronous processing during the import of multiple employee records, addressing potential webpage delays and ensuring a seamless data management experience.

本網站的會員分為兩種，一種是公司帳號，一種是員工帳號，並且唯有公司帳號和身份為「人資」的員工帳號能夠管理員工資料。除了基本的單一員工資料建立，也能透過匯入 CSV 檔案建立多個員工帳號。透過 Sidekiq 進行非同步處理，在匯入多筆員工資料時進行非同步處理，解決資料寫入時可能的網頁延遲問題。

<img width="500" alt="CSV 匯入定建立員工資料" src="https://github.com/astrocamp/15th-SyncSquad/assets/136299906/75e6d488-8bcb-4b8c-8165-c6b934caadb2">

### 2. Project Management 專案管理

When accessing the project list, you can quickly locate specific projects through the search feature and view the highlighted keyword positions marked with a highlighter, allow users can find the keyword easily. Upon entering a project or creating a new one, you can categorize tasks within a "List" for more effective organization. Additionally, you have the ability to record relevant data such as time, location, and priority for individual tasks. Whether in "Board Mode" or "Calendar Mode" when viewing project details, you can easily modify task details through a drag-and-drop interface. All of these capabilities are made possible by integrating open-source packages, including Sortable, Ranked-model, and Full Calendar, providing an excellent user experience.

進入專案列表時，能夠經由搜尋列表快速查找特定專案，並且查看有標示螢光筆的關鍵字位置，讓使用者可以視覺感上更輕易的找到關鍵字內容。進入專案或是建立專案後，可以「任務」在「列表」內，以便進行更有效的分類。此外，你還有能為單一任務記錄相關的時間、地點和優先級等數據。在「看板模式」或「行事曆模式」查看專案資料時，你可以輕鬆透過拖拉方式修改任務的細節。這一切皆得益於結合了開源套件，包括 Sortable、Ranked-model 以及 Full Calendar，提供優秀的操作體驗。

<img width="500" alt="專案卡片" src="https://github.com/astrocamp/15th-SyncSquad/assets/136299906/0c3b5023-852b-46e3-9a1b-a5b28d8bb317">
<img src="https://github.com/astrocamp/15th-SyncSquad/assets/136299906/3995c1ae-2ba0-42f4-92d6-e1f5d90b9d5f" alt="專案行事曆" width="500">

### 3. Communication Chatroom 即時聊天室

In our multifunctional chat environment, we provide private group chat rooms, one-on-one chat rooms for confidential discussions, and public group chat rooms for open conversations. These options cater to various communication needs, allowing users to engage in private group discussions, have one-on-one conversations securely, or participate in public group chats for more open interactions. Through the integration of Turbo and Action Cable, users can enjoy real-time updates, receive notifications for unread messages, and stay informed with the latest discussions, whether accessing the platform via a web browser or a mobile device. Our responsive design interface ensures that instant communication meets the synchronization requirements of teams, regardless of the device used.

多功能的聊天環境中，包含私人聊天室，用於保密的一對一對話，以及公開聊天室。以上功能得以滿足使用者不同的溝通需求，讓使用者參與私密的群組討論，進行保有隱私的一對一談話，或者在公開聊天室發表開放的言論。透過 Turbo 和 Action Cable，使用者能夠獲得聊天室的即時更新，收到未讀訊息通知，並隨時掌握最新的討論內容。不論是使用網頁瀏覽器還是手機，透過我們的響應式設計介面設計，都能確實滿足團隊的資訊同步需求。

<img src="https://github.com/astrocamp/15th-SyncSquad/assets/136299906/f4cbd147-aa6c-4f59-b45a-675981fa37de" alt="即時聊天室" width="500">

## Technologies ── 技術運用及設定

### Technical 使用技術

- Back-end 後端：Ruby on Rails
- Front-end 前端：HTML, CSS, JS, Tailwind CSS, Stimulus, Turbo
- Deployment 部署：Render
- Version Control 版本控制：Git, GitHub
- Database 資料庫：PostgreSQL, Redis, AWS S3
- Third-Party APIs 第三方服務：Google Maps, Line Pay
- Other Tools 其他工具：Figma

### Requirements 環境需求

- Ruby 3.2.2
- Rails 7.1.2
- PostgreSQL 14
- Redis
- Sidekiq
- imagemagick
- libvips 7

### Setup Steps 設定步驟

```
$ bundle install
$ yarn install
$ rails db:setup
$ redis-server
$ bundle exec sidekiq
$ bin/dev
```

## Contributor ── 開發團隊

### 劉昀瑄 (Willa Liu)

<img width="18" src="https://cdn4.iconfinder.com/data/icons/iconsimple-logotypes/512/github-512.png" alt="GitHub Icon"> GitHub：[Liu-Yun-Syuan](https://github.com/Liu-Yun-Syuan)

- Project Management 專案管理
- Permission Settings 權限設定
- Calendar Integration 行事曆串接
- Responsive Web Design (RWD) 響應式網頁設計

### 劉怡萍 (Arance Liu)

<img width="18" src="https://cdn4.iconfinder.com/data/icons/iconsimple-logotypes/512/github-512.png" alt="GitHub Icon"> GitHub：[AranceLiu](https://github.com/AranceLiu)

- Calendar Features 行事曆功能
- CSV Import CSV 匯入
- Project Search 專案搜尋
- Map Integration 地圖串接

### 趙奕寰 (Tim Chao)

<img width="18" src="https://cdn4.iconfinder.com/data/icons/iconsimple-logotypes/512/github-512.png" alt="GitHub Icon"> GitHub：[TimChaoTW](https://github.com/TimChaoTW)

- Communication Chatroom 即時聊天室
- Text Styles 文字樣式
- Avatar Upload 頭像上傳
- Payment Integration 金流串接

### 林韋如 (Ruby Lin)

<img width="18" src="https://cdn4.iconfinder.com/data/icons/iconsimple-logotypes/512/github-512.png" alt="GitHub Icon"> GitHub：[ryoma510260](https://github.com/ryoma510260)

- Multilingual Support 支援多國語言
- Member System 會員系統
- Website Deployment 網站部署
- AWS S3 Integration AWS S3 串接
