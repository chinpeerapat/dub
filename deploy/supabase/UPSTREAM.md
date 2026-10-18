The database, PostgREST, Storage, and imgproxy definitions and initialization SQL
come from Supabase's Docker distribution at commit
[7425d4930528931400fb3e656e860b1094cb224e](https://github.com/supabase/supabase/tree/7425d4930528931400fb3e656e860b1094cb224e/docker).

Local changes remove unused services and fixed container names, bind the database
port to loopback, allow additional database startup time, and persist uploaded
files in a named Docker volume for cross-platform filesystem compatibility.

Upstream license: [Apache 2.0](https://github.com/supabase/supabase/blob/7425d4930528931400fb3e656e860b1094cb224e/LICENSE).
