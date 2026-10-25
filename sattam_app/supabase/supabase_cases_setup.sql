-- ==========================================
-- SATTAM AI - MY CASES SUPABASE SETUP
-- ==========================================

-- 1. Create the cases table
CREATE TABLE IF NOT EXISTS public.cases (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT DEFAULT 'Active',
  next_hearing_date TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable Row Level Security (RLS) on the table
ALTER TABLE public.cases ENABLE ROW LEVEL SECURITY;

-- 3. Policy: Users can only see their own cases
DROP POLICY IF EXISTS "Users can view their own cases" ON public.cases;
CREATE POLICY "Users can view their own cases" 
  ON public.cases FOR SELECT 
  USING (auth.uid() = user_id);

-- 4. Policy: Users can only insert their own cases
DROP POLICY IF EXISTS "Users can insert their own cases" ON public.cases;
CREATE POLICY "Users can insert their own cases" 
  ON public.cases FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

-- 5. Policy: Users can only update their own cases
DROP POLICY IF EXISTS "Users can update their own cases" ON public.cases;
CREATE POLICY "Users can update their own cases" 
  ON public.cases FOR UPDATE 
  USING (auth.uid() = user_id);

-- 6. Policy: Users can only delete their own cases
DROP POLICY IF EXISTS "Users can delete their own cases" ON public.cases;
CREATE POLICY "Users can delete their own cases" 
  ON public.cases FOR DELETE 
  USING (auth.uid() = user_id);
