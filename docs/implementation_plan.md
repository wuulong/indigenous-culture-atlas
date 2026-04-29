# 原住民文化體系建置實作計畫 (Implementation Plan)

本計畫旨在將「原住民文化體系整理」任務 (T260429-HHH02) 轉化為可執行的階段性工程。

## 實作哲學 (Implementation Philosophy)
- **腳本驅動 (Script-Driven)**：優先撰寫 Python 或 SQL 腳本來執行資料更新與匯入，而非手動操作。
- **節省 Token (Token Efficiency)**：透過自動化腳本處理大量資料，避免在對話中傳遞冗長的原始數據。
- **工具化維護 (Tooling Strategy)**：循序漸進地建構穩定的匯入工具集，這有利於長期維護與資料的一致性。

## 階段一：原型驗證與自動化初始化 (Prototype & Automated Ingestion)
**預計時間：1-2 週**
- [ ] **DB 初始化**：執行 `init_schema.sql` 建立核心資料庫。
- [ ] **開放資料探勘與下載**：
    - 使用 `open-data-acquisition` 技能下載「核定部落結果」、「現住原住民人口數」與「傳統領域調查成果」等 CSV 檔案。
    - 存放於 `events/IndigenousCulture/data/open-data/`。
- [ ] **自動化匯入腳本開發**：
    - 撰寫 Python 腳本將官方部落清單轉換為 `communities` 與 `ethnic_groups` 的 SQL 插入語句。
- [ ] **排灣族種子案例深化**：
    - 在自動化匯入的基礎上，手動補充排灣族的階級、神話與支系架構。
- [ ] **驗證 Schema 完整性**：透過真實開放資料的匯入，檢視 `meta_data` 是否足以承載官方欄位。

## 階段二：核心資料規模化與清理 (Scale Core Data & Cleaning)
**預計時間：3-6 週**
- [ ] **全台 16 族架構自動化建置**：利用人口統計資料自動生成 `ethnic_groups` 頂層節點。
- [ ] **全台 700+ 核定部落匯入**：完成 `communities` 的批次匯入與地理座標校對。
- [ ] **傳統領域多邊形關聯**：將歷年調查成果與部落 ID 進行對應，建立初步領域索引。
- [ ] **文獻來源同步**：將開放資料的來源（如：原民會 Open Data 識別碼）存入 `references_source`。

---

## 💡 開放資料來源對照 (Open Data Source Mapping)
- **族群清單**：[現住原住民族種族別人口數](https://data.ntpc.gov.tw/api/datasets/ac89b3ad-6c64-47f4-b5d6-9af374e7c4ee/csv/file)
- **部落清單**：[核定部落結果](https://data.cip.gov.tw/API/v1/dump/datastore/A53000000A-112041-003)
- **傳統領域**：[歷年調查成果範圍](https://data.cip.gov.tw/API/v1/dump/datastore/A53000000A-106017-003)

## 階段三：深度知識建模 (Cultural Knowledge Modeling)
**預計時間：2-4 個月**
- [ ] **分族研究執行**：結合導讀框架 (T260429-HHH01)，針對重點族群進行 Deep Research。
- [ ] **傳統生態知識 (TEK) 錄入**：
    - 建立族群與自然資源（如：獵場、水源、祭祀植物）的連結。
    - 整合進「自然作為資產 (NAA)」框架。
- [ ] **遷徙歷史路徑化**：將口述與文獻中的遷徙歷史轉化為 `historical_timeline` 中的節點。

## 階段四：應用整合與 AI 賦能 (Integration & AI App)
**預計時間：長期目標**
- [ ] **WalkGIS 自動化同步**：開發腳本將 DB 資料轉換為 KML 格式，供實地探勘使用。
- [ ] **河流流域與文化對合分析**：建立「流域-部落-文化」的自動關聯報告。
- [ ] **AI 文化助理 (RAG)**：將結構化 DB 作為 LLM 的檢索底層，實現精準的文化導覽問答。

---

## 當前狀態 (Current Status)
- ✅ 專案目錄結構建立。
- ✅ 資料庫 Schema (v2) 與設計規格書完成。
- ⏳ 準備進入「階段一」之排灣族種子案例編寫。
