# 應用可能性與系統功能規劃 (Application Capabilities & Features)

本文件列出利用「原住民文化體系資料庫」可開發的 GIS 圖表、網站分析與檢索功能，作為未來應用開發的藍圖。

## 1. 空間分析功能 (GIS & Spatial Intelligence)

### 1.1 流域文化導航器 (River Basin Cultural Explorer)
- **核心邏輯**：利用 `communities.river_basin_id` 進行聚合。
- **功能**：
    - 使用者選擇特定流域（如：卑南溪），系統展示沿線部落分佈。
    - 結合 `cultural_assets`，分析水資源如何影響該區域的農事祭儀。
- **應用場景**：河流探勘報告自動生成。

### 1.2 傳統領域套疊分析 (Territory Overlay Analysis)
- **核心邏輯**：將 `communities.meta_data` 中的範圍資訊與外部圖層對合。
- **功能**：
    - 分析傳統領域與當前「國家公園」、「國有林班地」或「河川整治計畫」的重疊情形。
    - 識別潛在的文化敏感區位。

### 1.3 歷史遷徙路徑動畫 (Migration Path Animator)
- **核心邏輯**：讀取 `historical_timeline` 的時間與地點關聯。
- **功能**：
    - 在地圖上以動態線條展示族群隨時間移動的路徑（如：布農族向東與向南的遷徙）。

---

## 2. 知識導航與邏輯檢索 (Knowledge Graph Features)

### 2.1 文化語意圖譜 (Semantic Link Visualizer)
- **核心邏輯**：利用 `cultural_links` 建立節點網絡。
- **功能**：
    - 以力導向圖 (Force-directed graph) 呈現文化物件間的關聯（如：點擊「陶壺」，自動連出神話、族群、與特定的社會階級要求）。
- **應用場景**：文化研究、展覽規劃、教育導讀。

### 2.2 跨族群橫向比對引擎 (Cross-Ethnic Comparison Engine)
- **核心邏輯**：利用 `social_structures` 與 `cultural_categories`。
- **功能**：
    - 提供對照表，比較不同族群在相同範疇（如：繼承制度、婚嫁習俗）下的差異。
    - 自動識別「母系社會」與「父系社會」族群在地理分佈上的特徵。

---

## 3. 數據統計與圖表 (Visual Analytics)

### 3.1 文化資產季節年曆 (Cultural Seasonality Calendar)
- **核心邏輯**：分析 `cultural_assets.seasonality`。
- **功能**：
    - 建立全族群祭儀年曆。
    - 展示各月份在全台分佈的文化活動密度。

### 3.2 資料證據力統計 (Data Provenance Stats)
- **核心邏輯**：統計 `references_source` 與各表的關聯頻率。
- **功能**：
    - 展示資料庫的證據構成（官方文獻 vs. 學術研究 vs. 口述紀錄）。
    - 識別哪些族群或區域目前仍缺乏可靠的文獻支持，引導後續補齊。

---

## 4. 高階 AI 與 Web 應用整合

### 4.1 文化 RAG 智能助理 (AI Cultural Assistant)
- **核心邏輯**：將結構化 SQL 資料轉換為 LLM 檢索底層。
- **功能**：
    - 自然語言問答：「有哪些部落位於秀姑巒溪中游且有石板屋文化？」
    - 根據資料庫內容生成精準且有引註（Source-backed）的導覽建議。

### 4.2 彈性 Metadata 搜尋器 (Metadata Explorer)
- **核心邏輯**：針對 `meta_data` (JSON) 欄位進行全文檢索。
- **功能**：
    - 支援搜尋尚未結構化的隱藏屬性（如：特定材料名稱、爬蟲原始備註）。
