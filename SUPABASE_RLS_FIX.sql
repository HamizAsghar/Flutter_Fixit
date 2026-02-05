-- Fix for Row Level Security Policy on users table
-- This allows users to insert their own data after authentication

-- Drop existing insert policy if it exists
DROP POLICY IF EXISTS "Users can insert their own data" ON public.users;

-- Create new insert policy that allows authenticated users to insert their own data
CREATE POLICY "Users can insert their own data" ON public.users
  FOR INSERT 
  WITH CHECK (auth.uid() = id);

-- Also add a policy to allow service role to insert (for server-side operations)
CREATE POLICY "Service role can insert users" ON public.users
  FOR INSERT 
  WITH CHECK (auth.jwt()->>'role' = 'service_role');

-- Verify policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies
WHERE tablename = 'users';
