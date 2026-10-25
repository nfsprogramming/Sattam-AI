-- 1. Create the Evidence table
CREATE TABLE IF NOT EXISTS public.evidence (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    file_name TEXT NOT NULL,
    file_url TEXT NOT NULL,
    file_type TEXT NOT NULL,
    size BIGINT NOT NULL,
    category TEXT DEFAULT 'Uncategorized',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable RLS on the evidence table
ALTER TABLE public.evidence ENABLE ROW LEVEL SECURITY;

-- 2. Create Policies for the Evidence table
-- Allow users to view their own evidence
CREATE POLICY "Users can view their own evidence" 
ON public.evidence FOR SELECT 
USING (auth.uid() = user_id);

-- Allow users to insert their own evidence
CREATE POLICY "Users can insert their own evidence" 
ON public.evidence FOR INSERT 
WITH CHECK (auth.uid() = user_id);

-- Allow users to delete their own evidence
CREATE POLICY "Users can delete their own evidence" 
ON public.evidence FOR DELETE 
USING (auth.uid() = user_id);

-- 3. Set up Storage Bucket for Evidence Files
-- Create the bucket if it doesn't exist (Requires superuser privileges, often easier to do via the Supabase Dashboard UI)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('evidence_files', 'evidence_files', true)
ON CONFLICT (id) DO NOTHING;

-- 4. Create Policies for Storage Bucket
-- Allow users to view their own files in the bucket
CREATE POLICY "Users can view their own evidence files" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'evidence_files' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Allow users to upload files to their own folder in the bucket
CREATE POLICY "Users can upload their own evidence files" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'evidence_files' AND auth.uid()::text = (storage.foldername(name))[1]);

-- Allow users to delete their own files from the bucket
CREATE POLICY "Users can delete their own evidence files" 
ON storage.objects FOR DELETE 
USING (bucket_id = 'evidence_files' AND auth.uid()::text = (storage.foldername(name))[1]);
