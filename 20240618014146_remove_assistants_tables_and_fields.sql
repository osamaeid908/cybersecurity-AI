-- REMOVE ASSISTANTS

-- DROP TRIGGERS FOR ASSISTANTS
DROP TRIGGER IF EXISTS update_assistants_updated_at ON assistants;
DROP TRIGGER IF EXISTS delete_old_assistant_image ON assistants;
DROP TRIGGER IF EXISTS update_assistant_workspaces_updated_at ON assistant_workspaces;
DROP TRIGGER IF EXISTS update_assistant_files_updated_at ON assistant_files;
DROP TRIGGER IF EXISTS update_assistant_tools_updated_at ON assistant_tools;

-- DROP POLICIES FOR ASSISTANTS
-- DROP POLICY IF EXISTS "Allow full access to own assistants" ON assistants;
-- DROP POLICY IF EXISTS "Allow view access to non-private assistants" ON assistants;

-- DROP POLICIES FOR STORAGE
DROP POLICY IF EXISTS "Allow public read access on non-private assistant images" ON storage.objects;
DROP POLICY IF EXISTS "Allow insert access to own assistant images" ON storage.objects;
DROP POLICY IF EXISTS "Allow update access to own assistant images" ON storage.objects;
DROP POLICY IF EXISTS "Allow delete access to own assistant images" ON storage.objects;

-- DROP DEPENDENT OBJECTS FOR ASSISTANTS
-- ALTER TABLE assistant_files DROP CONSTRAINT IF EXISTS assistant_files_assistant_id_fkey;
-- ALTER TABLE assistant_tools DROP CONSTRAINT IF EXISTS assistant_tools_assistant_id_fkey;
-- ALTER TABLE assistant_workspaces DROP CONSTRAINT IF EXISTS assistant_workspaces_assistant_id_fkey;
ALTER TABLE chats DROP CONSTRAINT IF EXISTS chats_assistant_id_fkey;

-- DROP INDEXES FOR ASSISTANTS
DO $$ 
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'assistants') THEN
        ALTER TABLE assistants DROP CONSTRAINT IF EXISTS assistants_pkey CASCADE;
    END IF;
END $$;
DROP INDEX IF EXISTS assistants_user_id_idx;
DROP INDEX IF EXISTS assistants_pkey;

-- DROP INDEXES FOR ASSISTANT WORKSPACES
DROP INDEX IF EXISTS assistant_workspaces_user_id_idx;
DROP INDEX IF EXISTS assistant_workspaces_assistant_id_idx;
DROP INDEX IF EXISTS assistant_workspaces_workspace_id_idx;
DROP INDEX IF EXISTS assistant_workspaces_pkey;

-- DROP INDEXES FOR ASSISTANT FILES
DROP INDEX IF EXISTS assistant_files_user_id_idx;
DROP INDEX IF EXISTS assistant_files_assistant_id_idx;
DROP INDEX IF EXISTS assistant_files_file_id_idx;
DROP INDEX IF EXISTS assistant_files_pkey;

-- DROP INDEXES FOR ASSISTANT TOOLS
DROP INDEX IF EXISTS assistant_tools_user_id_idx;
DROP INDEX IF EXISTS assistant_tools_assistant_id_idx;
DROP INDEX IF EXISTS assistant_tools_tool_id_idx;
DROP INDEX IF EXISTS assistant_tools_pkey;

-- DROP TABLES FOR ASSISTANTS
DROP TABLE IF EXISTS assistant_workspaces;
DROP TABLE IF EXISTS assistants;
DROP TABLE IF EXISTS assistant_files;
DROP TABLE IF EXISTS assistant_tools;

-- REMOVE STORAGE BUCKET
-- DELETE FROM storage.buckets WHERE name = 'assistant_images';

-- REMOVE REFERENCES TO ASSISTANTS IN CHATS
ALTER TABLE chats DROP CONSTRAINT IF EXISTS chats_assistant_id_fkey;

-- DROP FUNCTION
DROP FUNCTION IF EXISTS public.non_private_assistant_exists(p_name text);