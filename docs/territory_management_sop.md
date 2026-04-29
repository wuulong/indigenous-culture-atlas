# 傳統領域空間資訊管理指引 (Traditional Territory Management SOP)

本文件說明如何利用現有的資料庫架構，有效整理與記錄原住民族的「傳統領域」空間資訊。

## 1. 領域資料的階層與定義

在資料庫中，傳統領域區分為三種性質：
- **部落點位 (Point)**：部落的地理中心（如：祭祀廣場、集會所）。
- **部落領域 (Polygon)**：特定部落所主張或公告的具體邊界。
- **族群文化圈 (Regional/Ethnic Sphere)**：較大尺度的文化分佈範圍。

---

## 2. 資料庫記錄路徑 (Mapping Logic)

### A. 基礎資料錄入 (`communities` 表)
- **點位資訊**：直接存儲於 `longitude`, `latitude`, `altitude`。
- **範圍資訊**：
    - **方法一（外部連結）**：在 `meta_data` (JSON) 中存入 KML 檔案路徑或國土測繪雲的 API 連結。
    - **方法二（內部儲存）**：在 `meta_data` 中存入 WKT (Well-Known Text) 格式的邊界字串。

### B. 族群關聯與彙整 (`community_groups` 表)
- 透過多對多關聯，可以將多個部落的「個別領域」聯集起來，形成該「族群」或「支系」的總體領域。
- 若為混居部落，可標註 `is_primary` 判定該領域在行政或文化上的主導權。

### C. 特殊地景連結 (`cultural_links` 表)
- 用於記錄**「非特定部落專屬」**或**「多部落共有」**的神聖地景（如：北大武山、秀姑巒溪）。
- **範例**：`[排灣族] -- sacred_site --> [大武山]`。

---

## 3. 實務操作流程

### 第一步：獲取原始圖資
- 從「政府資料開放平臺」或「國土測繪圖資服務雲」下載 **KML** 或 **SHP** 檔案。

### 第二步：提取 Metadata
- 獲取該領域的「公告文號」、「公告日期」與「檔案編號」。

### 第三步：寫入資料庫
範例 SQL 操作：
```sql
-- 1. 建立來源
INSERT INTO references_source (title, note) VALUES ('原民會傳統領域公告-第XXX號', '202X年公告');

-- 2. 建立部落點位與領域連結
INSERT INTO communities (name_zh, longitude, latitude, source_id, meta_data)
VALUES (
    '太巴塱部落', 
    121.439, 23.666, 
    last_insert_rowid(), 
    '{"kml_link": "data/kml/tafalong_territory.kml", "area_size": "2500ha"}'
);

-- 3. 建立族群關聯
INSERT INTO community_groups (community_id, group_id, is_primary) 
VALUES (last_insert_rowid(), (SELECT id FROM ethnic_groups WHERE name_zh='阿美族'), 1);
```

---

## 4. 空間運算與應用建議

1. **WalkGIS 同步**：讀取 `communities.meta_data` 中的 `kml_link`，在行動端地圖上同時呈現「部落點」與「領域面」。
2. **流域交集分析**：比對 `communities.river_basin_id` 與領域範圍，產出「XX 流域內的部落傳統領域清冊」。
3. **證據回溯**：所有領域範圍必須有 `source_id` 對應到 `references_source`，以區分「官方公告範圍」與「學術調查範圍」。
