-- [修訂版] 原住民文化體系 SQLite 初始化腳本
-- 強化點：多對多族群關聯 (1)、全面證據溯源 (5)、各表擴充彈性 (meta_data)

-- 1. 文獻與參考資料
CREATE TABLE IF NOT EXISTS references_source (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author TEXT,
    publish_year INTEGER,
    url_link TEXT,
    file_path TEXT,
    note TEXT,
    meta_data TEXT                  -- JSON 格式擴充欄位
);

-- 2. 族群基本定義
CREATE TABLE IF NOT EXISTS ethnic_groups (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    parent_id INTEGER,               -- 指向父層族群 ID (支援支系)
    name_zh TEXT NOT NULL,
    name_native TEXT,
    language_family TEXT,
    description TEXT,
    source_id INTEGER,               -- 來源引註
    status TEXT DEFAULT 'official',
    meta_data TEXT,                  -- JSON 格式擴充欄位
    FOREIGN KEY (parent_id) REFERENCES ethnic_groups(id),
    FOREIGN KEY (source_id) REFERENCES references_source(id)
);

-- 3. 部落/聚落 (空間核心)
CREATE TABLE IF NOT EXISTS communities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_zh TEXT NOT NULL,
    name_native TEXT,
    region_admin TEXT,
    river_basin_id TEXT,
    longitude REAL,
    latitude REAL,
    altitude REAL,
    poi_type TEXT,
    source_id INTEGER,               -- 來源引註
    meta_data TEXT,                  -- JSON 格式擴充欄位
    FOREIGN KEY (source_id) REFERENCES references_source(id)
);

-- 4. 部落-族群多對多關聯表
CREATE TABLE IF NOT EXISTS community_groups (
    community_id INTEGER,
    group_id INTEGER,
    is_primary INTEGER DEFAULT 1,    -- 是否為主導族群
    note TEXT,
    meta_data TEXT,                  -- JSON 格式擴充欄位
    PRIMARY KEY (community_id, group_id),
    FOREIGN KEY (community_id) REFERENCES communities(id),
    FOREIGN KEY (group_id) REFERENCES ethnic_groups(id)
);

-- 5. 文化範疇定義
CREATE TABLE IF NOT EXISTS cultural_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name TEXT NOT NULL,
    parent_id INTEGER,
    meta_data TEXT,                  -- JSON 格式擴充欄位
    FOREIGN KEY (parent_id) REFERENCES cultural_categories(id)
);

-- 6. 文化知識/資產項目
CREATE TABLE IF NOT EXISTS cultural_assets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    community_id INTEGER,
    category_id INTEGER,
    title TEXT NOT NULL,
    content_description TEXT,
    seasonality TEXT,
    nature_asset_link TEXT,
    media_url TEXT,
    is_shared_by_group INTEGER DEFAULT 0, -- 是否為族群共有 (1:是, 0:否)
    source_id INTEGER,               -- 來源引註
    meta_data TEXT,                  -- JSON 格式擴充欄位
    FOREIGN KEY (community_id) REFERENCES communities(id),
    FOREIGN KEY (category_id) REFERENCES cultural_categories(id),
    FOREIGN KEY (source_id) REFERENCES references_source(id)
);

-- 7. 歷史與遷徙事件
CREATE TABLE IF NOT EXISTS historical_timeline (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    group_id INTEGER,
    community_id INTEGER,
    event_year TEXT,
    event_title TEXT,
    event_description TEXT,
    source_id INTEGER,               -- 來源引註
    meta_data TEXT,                  -- JSON 格式擴充欄位
    FOREIGN KEY (group_id) REFERENCES ethnic_groups(id),
    FOREIGN KEY (community_id) REFERENCES communities(id),
    FOREIGN KEY (source_id) REFERENCES references_source(id)
);

-- 8. 社會組織模型 (階級、繼承規則等)
CREATE TABLE IF NOT EXISTS social_structures (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    group_id INTEGER,
    structure_name TEXT, 
    content_rule TEXT,   
    source_id INTEGER,               -- 來源引註
    meta_data TEXT,                  -- JSON 格式擴充欄位
    FOREIGN KEY (group_id) REFERENCES ethnic_groups(id),
    FOREIGN KEY (source_id) REFERENCES references_source(id)
);

-- 9. 文化知識連結表
CREATE TABLE IF NOT EXISTS cultural_links (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    source_type TEXT,    
    source_id INTEGER,
    relation TEXT,       
    target_type TEXT,
    target_id INTEGER,
    description TEXT,
    ref_source_id INTEGER,
    meta_data TEXT,
    FOREIGN KEY (ref_source_id) REFERENCES references_source(id)
);

-- 10. 人物與組織實體 (工藝師、耆老、研究者、組織)
CREATE TABLE IF NOT EXISTS people_entities (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name_zh TEXT NOT NULL,
    name_native TEXT,
    group_id INTEGER,                -- 所屬族群
    community_id INTEGER,            -- 所屬部落
    expertise TEXT,                  -- 專長 (如：木雕、口述歷史)
    biography TEXT,                  -- 簡介
    contact_info TEXT,               -- 聯絡資訊
    source_id INTEGER,               -- 來源引註
    meta_data TEXT,                  -- JSON 格式擴充
    FOREIGN KEY (group_id) REFERENCES ethnic_groups(id),
    FOREIGN KEY (community_id) REFERENCES communities(id),
    FOREIGN KEY (source_id) REFERENCES references_source(id)
);

-- 11. 族語詞彙庫 (Lexicon)
CREATE TABLE IF NOT EXISTS lexicon (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    term_native TEXT NOT NULL,       -- 族語詞彙
    term_zh TEXT NOT NULL,           -- 中文對應
    pronunciation TEXT,              -- 讀音/拼音
    group_id INTEGER,                -- 屬於哪個族群/方言
    category_id INTEGER,             -- 分類 (如：動植物、祭儀用語)
    definition TEXT,                 -- 詳細定義
    example_sentence TEXT,           -- 例句
    source_id INTEGER,               -- 來源引註
    meta_data TEXT,                  -- JSON 格式擴充
    FOREIGN KEY (group_id) REFERENCES ethnic_groups(id),
    FOREIGN KEY (category_id) REFERENCES cultural_categories(id),
    FOREIGN KEY (source_id) REFERENCES references_source(id)
);
