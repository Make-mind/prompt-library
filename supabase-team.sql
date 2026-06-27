-- 团队共享模式：所有人看到同一份数据
DROP POLICY IF EXISTS "prompts_self" ON prompts;
DROP POLICY IF EXISTS "logs_self" ON generation_logs;
DROP POLICY IF EXISTS "workflows_self" ON workflows;
DROP POLICY IF EXISTS "memos_self" ON memos;

CREATE POLICY "prompts_team" ON prompts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "logs_team" ON generation_logs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "workflows_team" ON workflows FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "memos_team" ON memos FOR ALL USING (true) WITH CHECK (true);
