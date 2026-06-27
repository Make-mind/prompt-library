-- 提示词库团队版 · 数据库建表脚本（修正版）
-- 如果表已存在则先删除再重建
-- ⚠️ 这会清空表中已有数据！如果之前有测试数据会被删掉

DROP TABLE IF EXISTS memos CASCADE;
DROP TABLE IF EXISTS workflows CASCADE;
DROP TABLE IF EXISTS generation_logs CASCADE;
DROP TABLE IF EXISTS prompts CASCADE;

-- 1. prompts 表
CREATE TABLE prompts (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL DEFAULT auth.uid(),
  title       TEXT NOT NULL DEFAULT '',
  tool        TEXT DEFAULT '',
  media_type  TEXT DEFAULT '',
  scenario    TEXT DEFAULT '',
  tags        TEXT[] DEFAULT '{}',
  result      TEXT DEFAULT '',
  rating      INT DEFAULT 5,
  cost        FLOAT DEFAULT 0,
  usage_count INT DEFAULT 0,
  dimensions  JSONB DEFAULT '{}',
  attachments JSONB DEFAULT '[]',
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- 2. generation_logs 表
CREATE TABLE generation_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL DEFAULT auth.uid(),
  prompt_id   UUID,
  tool        TEXT DEFAULT '',
  prompt_text TEXT DEFAULT '',
  cost        FLOAT DEFAULT 0,
  result      TEXT DEFAULT 'success',
  image_count INT DEFAULT 0,
  usable_count INT DEFAULT 0,
  notes       TEXT DEFAULT '',
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- 3. workflows 表
CREATE TABLE workflows (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL DEFAULT auth.uid(),
  name        TEXT DEFAULT '新工作流',
  data        JSONB DEFAULT '{"nodes":[],"connections":[]}',
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- 4. memos 表
CREATE TABLE memos (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL DEFAULT auth.uid(),
  title       TEXT DEFAULT '新笔记',
  content     TEXT DEFAULT '',
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ====== RLS 策略 ======
ALTER TABLE prompts ENABLE ROW LEVEL SECURITY;
ALTER TABLE generation_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE workflows ENABLE ROW LEVEL SECURITY;
ALTER TABLE memos ENABLE ROW LEVEL SECURITY;

-- 删除旧策略（如果存在）再新建
DROP POLICY IF EXISTS "prompts_self" ON prompts;
DROP POLICY IF EXISTS "logs_self" ON generation_logs;
DROP POLICY IF EXISTS "workflows_self" ON workflows;
DROP POLICY IF EXISTS "memos_self" ON memos;

CREATE POLICY "prompts_self" ON prompts FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY "logs_self"    ON generation_logs FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY "workflows_self" ON workflows FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
CREATE POLICY "memos_self"   ON memos FOR ALL USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());
