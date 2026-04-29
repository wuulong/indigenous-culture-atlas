# AI Agent 輔助指引：原住民文化體系建模與應用 (AI Agent Guide)

本文件專為協助 AI 代理程式（如 Antigravity）理解、操作與擴充「原住民文化體系資料庫」而設計。當 AI 需要參與資料錄入、SQL 撰寫或文化分析時，應優先閱讀本指南。

## 1. 系統核心邏輯 (Core Logic)

AI 應理解本系統並非單純的扁平清單，而是**三位一體**的結構：
1.  **關係層 (Relational)**：族群 -> 支系 -> 部落的嚴謹階層。
2.  **空間層 (Spatial)**：點位 (GPS) 與範圍 (Territory) 的連結，並與「河流流域」對合。
3.  **語意層 (Semantic)**：透過 `cultural_links` 建立知識物件間的因果與象徵關係。

---

## 2. AI 錄入與建模規範 (Data Ingestion Rules)

當 AI 被要求錄入新資料時，必須遵循以下準則：
- **證據先行 (Source Mandatory)**：每一筆數據必須先在 `references_source` 建立來源，並在該筆資料引用 `source_id`。
- **腳本優於手動 (Prefer Scripts)**：禁止在對話中手動輸入大量資料。AI 應撰寫 Python 腳本讀取檔案並生成 SQL 語句。這能顯著節省 Token，並確保操作的可重複性。
- **建立穩定工具 (Stable Tooling)**：在建構過程中，致力於開發可複用的匯入與檢索腳本，建立長期維護的基礎。
- **區分共享與獨有**：正確使用 `is_shared_by_group`。如果是全族傳說（如：排灣族百步蛇）則標為 1；若是部落特定習俗，則標為 0。
- **故事導讀模式 (Storytelling Mode)**：在產出 `cultural_assets` 的內容時，應包含一段「適合在田野現場朗讀」的導覽語氣摘要。內容應具備地景連結感（例如：連結到眼前的溪流、山脈或特定的部落入口標誌）。
- **活用 Meta Data**：若遇到 Schema 未定義的細節（如：特定工藝的材料配方），應將其格式化為 JSON 存入 `meta_data`。
- **支系管理**：錄入部落前，應檢查其所屬的子族群（支系）是否存在於 `ethnic_groups`，確保 `parent_id` 正確。

---

## 3. 查詢策略指引 (Querying Strategy)

AI 在撰寫查詢 SQL 時應考慮：
- **跨維度檢索**：結合 `community_groups` (族群) 與 `communities` (流域) 進行空間-文化交叉分析。
- **圖譜遍歷**：利用 `cultural_links` 尋找物件間的深層關聯，而不僅是關鍵字比對。

---

## 4. 關鍵細節與附件索引 (Attachments & Details)

當 AI 需要更深入的技術細節時，應查閱以下檔案：

| 類別 | 檔案路徑 | 目的 |
| :--- | :--- | :--- |
| **資料定義** | [init_schema.sql](../db/init_schema.sql) | 查看最新的 SQL 表結構、外鍵限制與欄位型別。 |
| **設計規範** | [db_design_spec.md](db_design_spec.md) | 理解各表設計背後的哲學與業務邏輯。 |
| **空間管理** | [territory_management_sop.md](territory_management_sop.md) | 學習如何處理傳統領域、KML 連結與空間對合。 |
| **實作計畫** | [implementation_plan.md](implementation_plan.md) | 了解目前的專案階段與未來擴充方向。 |
| **種子案例** | [seed_case_selection.md](seed_case_selection.md) | 了解為何選擇排灣族作為首個建模基準。 |
| **應用願景** | [application_capabilities.md](application_capabilities.md) | 了解資料庫預計支持的 GIS、圖表與 AI 應用功能。 |

---

## 5. 給 AI 的操作命令範例 (Prompt Examples)

> **"請幫我將排灣族拉瓦爾支系的創世神話寫成 SQL，並建立與太陽、陶壺、百步蛇的連結關係。"**
> (AI 應先查詢 `ethnic_groups` 獲取 ID，再寫入 `cultural_assets`，最後建立 `cultural_links`)

> **"請分析當前資料庫中，分布在卑南溪流域的布農族部落清單。"**
> (AI 應 Join `communities` 與 `community_groups`)
