-- ==========================================
-- SATTAM AI - EVIDENCE LOCKER SUPABASE SETUP
-- ==========================================

-- 1. Create the Evidence metadata table
CREATE TABLE IF NOT EXISTS public.evidence (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  file_name TEXT NOT NULL,
  file_url TEXT NOT NULL,
  file_type TEXT NOT NULL,
  size BIGINT NOT NULL,
  category TEXT DEFAULT 'Uncategorized',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable Row Level Security (RLS) on the table
ALTER TABLE public.evidence ENABLE ROW LEVEL SECURITY;

-- 3. Policy: Users can only see their own evidence records
DROP POLICY IF EXISTS "Users can view their own evidence" ON public.evidence;
CREATE POLICY "Users can view their own evidence" 
  ON public.evidence FOR SELECT 
  USING (auth.uid() = user_id);

-- 4. Policy: Users can only insert their own evidence records
DROP POLICY IF EXISTS "Users can insert their own evidence" ON public.evidence;
CREATE POLICY "Users can insert their own evidence" 
  ON public.evidence FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

-- 5. Create the Storage Bucket for the actual files
INSERT INTO storage.buckets (id, name, public)
VALUES ('evidence_files', 'evidence_files', true)
ON CONFLICT (id) DO NOTHING;

-- 6. Policy: Authenticated users can upload files to their own folder in the bucket
DROP POLICY IF EXISTS "Users can upload evidence files" ON storage.objects;
CREATE POLICY "Users can upload evidence files" 
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'evidence_files' AND 
    (storage.foldername(name))[1] = auth.uid()::text
  );

-- 7. Policy: Allow users to view/download files
DROP POLICY IF EXISTS "Public can view evidence files" ON storage.objects;
CREATE POLICY "Public can view evidence files" 
  ON storage.objects FOR SELECT TO public
  USING (bucket_id = 'evidence_files');
