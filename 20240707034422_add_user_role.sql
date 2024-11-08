-- Add role column to profiles table
ALTER TABLE profiles
ADD COLUMN role TEXT NOT NULL DEFAULT 'normal' CHECK (role IN ('normal', 'moderator'));

-- Update existing profiles to have 'normal' role
UPDATE profiles SET role = 'normal' WHERE role IS NULL;

-- Add comment to explain the role column
COMMENT ON COLUMN profiles.role IS 'User role: normal or moderator';

-- Create a function to check if a user is a moderator
CREATE OR REPLACE FUNCTION is_moderator(test_user_id UUID)
RETURNS BOOLEAN AS $$
DECLARE
    user_role TEXT;
BEGIN
    SELECT role INTO user_role
    FROM profiles
    WHERE user_id = test_user_id;

    IF user_role IS NULL THEN
      RETURN FALSE;
    END IF;
    
    RETURN user_role = 'moderator';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Add comment to explain the function
COMMENT ON FUNCTION is_moderator(UUID) IS 'Checks if the given user ID belongs to a moderator';
