# 原住民文化體系資料庫設計規格書 (Database Design Specification)

## 1. 設計哲學 (Design Philosophy)

本資料庫旨在整合**族群、空間、文化知識與歷史時間**四個維度，並以「證據溯源」為核心，確保每一筆錄入的資訊都有學術或事實根據。

### 核心原則：
- **關係完整性**：支援跨族群混居、支系階層化等現實複雜情況。
- **證據導向**：所有文化資產與歷史事件必須連結至來源文獻。
- **彈性擴充**：透過 `meta_data` (JSON) 支援未來未知的屬性需求。
- **知識圖譜化**：不僅存儲物件，更存儲物件間的邏輯關係 (Links)。

---

## 2. 資料表詳解 (Table Definitions)

### 2.1 基礎架構
| 資料表 | 用途 | 關鍵欄位說明 |
| :--- | :--- | :--- |
| `references_source` | **來源中心** | 儲存所有文獻、口述紀錄、數位典藏的引用資訊。 |
| `ethnic_groups` | **族群定義** | 支援支系架構 (`parent_id`)，如排灣族及其子支系。 |

### 2.2 空間與歸屬
| 資料表 | 用途 | 關鍵欄位說明 |
| :--- | :--- | :--- |
| `communities` | **空間單位** | 儲存部落、舊社的 GPS 座標、行政區與關聯流域。 |
| `community_groups` | **族群關聯** | 解決「混居」問題。一個部落可對應多族群，並標註主從關係。 |

### 2.3 文化資產與分類
| 資料表 | 用途 | 關鍵欄位說明 |
| :--- | :--- | :--- |
| `cultural_categories`| **分類體系** | 階層式分類，如：`祭儀 -> 農事祭儀 -> 小米祭`。 |
| `cultural_assets` | **文化知識項** | 儲存特定儀式、工藝、TEK 的具體內容。具備 `is_shared_by_group` 欄位區分「族群共有」或「部落獨有」。 |

### 2.4 時間與系統規則
| 資料表 | 用途 | 關鍵欄位說明 |
| :--- | :--- | :--- |
| `historical_timeline`| **歷史時間軸** | 紀錄遷徙、戰爭或重大文化變遷事件。 |
| `social_structures` | **社會規則** | 紀錄如「階級制度」、「繼承規則」等系統性規範。 |

### 2.5 人物與語言
| 資料表 | 用途 | 關鍵欄位說明 |
| :--- | :--- | :--- |
| `people_entities` | **人物與組織** | 紀錄耆老、工藝師、研究者或特定部落組織。 |
| `lexicon` | **族語詞彙庫** | 紀錄文化核心詞彙（如：祭儀用語、特定植物族語名）。 |

### 2.6 知識圖譜 (Knowledge Graph)
| 資料表 | 用途 | 關鍵欄位說明 |
| :--- | :--- | :--- |
| `cultural_links` | **邏輯連結** | 定義物件間的因果、象徵或守護關係（如：百步蛇與陶壺）。 |

---

## 3. 核心設計模式 (Key Design Patterns)

### 3.1 證據溯源模式 (Evidence-based Modeling)
大部分資料表都強制包含 `source_id` 欄位。
- **目的**：避免資料淪為無根據的傳聞，便於日後回溯學術來源。

### 3.2 自關聯階層模式 (Self-referencing Hierarchy)
`ethnic_groups` 與 `cultural_categories` 均使用 `parent_id` 自關聯。
- **目的**：能處理無限深度的分類與支系結構。
- **RAG 串接**：此結構非常適合轉換為 LLM 的向量資料庫或 RAG 檢索底層。

### 3.3 彈性 Meta 模式 (JSON Metadata)
所有資料表均保留 `meta_data` (TEXT) 欄位。
- **目的**：解決結構化資料庫 (SQL) 難以應對非結構化資料 (NoSQL) 的問題，適合存儲抓取的原始 API 回應。

---

## 7. 高階應用與治理規範 (Advanced Application & Governance)

### 7.1 時空感知與活動雷達 (Temporal Awareness)
- **活動行事曆 (`cultural_events`)**：系統必須具備處理動態日期的能力，以支援「探勘不失之交臂」的需求。
- **時空查詢邏輯**：系統應能執行 `(當前時間 + 附近座標) -> 推薦活動` 的複合查詢。

### 7.2 故事導讀模式 (Storytelling Mode)
- **地景感描述**：`cultural_assets` 中的敘事應具備「現地感」，包含對周邊河流、山脈與部落入口的指引性描述。
- **敘事分級**：區分「全族共有神話」與「部落特有故事」。

### 7.3 專案治理原則 (Governance)
- **版本化管理**：DB 與專書共享 `VERSION` 號，確保數據與敘事的一致性。
- **建置紀錄 (Build Log)**：所有資料變更與書本構建必須記錄於 `build_log.md`。
- **內外解耦**：採用 Git Submodule 管理公開 Repo，落實「主目錄為內，子目錄為公」的治理策略。
- **腳本驅動**：優先開發自動化工具 (Python/SQL) 處理資料，節省 Token 並確保可維護性。

---

## 8. 數據標準化與分析就緒規範 (Data Standardization & Analytical Ready)

### 8.1 建議的 Meta Data JSON 鍵值清單
為了確保未來分析系統能解析 `meta_data` 欄位，AI 錄入時應優先使用以下 Key：
- **媒體類 (`media_info`)**：`{"mimetype": "image/jpeg", "width": 1920, "height": 1080, "duration": 120}`
- **田野筆記 (`field_notes`)**：`{"observer": "Name", "date": "YYYY-MM-DD", "location_precision": "high"}`
- **技術細節 (`tech_specs`)**：`{"material": ["wood", "rattan"], "technique": "weaving", "complexity": 3}`
- **語意摘要 (`semantic_summary`)**：專供 RAG 使用的純文字摘要，包含高密度關鍵字。

### 8.2 平行敘事與衝突處理邏輯
當同一文化資產具備多個衝突版本時：
1. **多筆錄入**：針對不同來源分別建立 `cultural_assets` 紀錄，透過 `source_id` 區分。
2. **衝突標籤**：在 `meta_data` 加入 `{"narrative_group": "Group_A", "conflict_with": [id1, id2]}`。
3. **分析系統行為**：系統應具備「並排顯示」功能，而非強制選擇單一真相。

---

## 4. 實例操作建議

### 記錄「排灣族」案例：
1. **族群**：建立 `排灣族` (ID:1) -> 建立 `拉瓦爾支系` (Parent:1)。
2. **社會結構**：建立一筆 `階級制度` 關聯到 ID:1。
3. **來源**：建立一筆 `原民會影片` 到 `references_source`。
4. **資產**：建立 `陶壺`、`百步蛇`，並分別關聯到上述來源。
5. **連結**：建立 `百步蛇 -- guardian_of --> 陶壺`。

---
## 6. 資料採集與統一來源指引 (Data Acquisition & Unified Sources)

為了確保資料的權威性與錄入效率，建議 AI 與開發者優先參考以下三大「統一入口」：

### 6.1 臺灣原住民族資訊資源網 (TIPP)
- **網址**：[www.tipp.org.tw](https://www.tipp.org.tw/)
- **用途**：獲取部落背景描述、歷史遷徙文字、以及祭儀文化的深度介紹。
- **對應 DB**：`cultural_assets.content_description`、`historical_timeline`。

### 6.2 原住民族委員會資料開放平臺 (CIP Open Data)
- **網址**：[data.cip.gov.tw](https://data.cip.gov.tw/)
- **用途**：獲取結構化的 CSV/JSON 資料，包含核定部落名單、人口統計、傳統領域範圍。
- **對應 DB**：`ethnic_groups`、`communities`、`community_groups`。

### 6.3 族語 E 樂園 (Klokah)
- **網址**：[web.klokah.tw](https://web.klokah.tw/)
- **用途**：獲取族語詞彙、讀音、圖畫故事以及多媒體影音。
- **對應 DB**：`lexicon`、`cultural_assets.media_url`。
