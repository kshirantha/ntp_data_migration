When copying initial script to SFC Migration please remove followings

	1. CSM Build Scripts
		a. Remove SYS fodler
		b. Update excute.bat & excute.sh files
		c. Remove run.sql (If Exists - Recompile from SYS Option)
		d. Disable jobs (If Exists)
		
	2. NTP Build Scripts
		a. Remove SYS fodler
		b. Add recompile.bat
		c. Update excute.bat files (Remove Sys References & Set Parameters + Add call recompile %str1%  %str2%  %str3%  %str4% %str5% %str6% %str7%)
		d. Remove run.sql
		e. Remove dfn_dba.sql
		f. Replace Setup.bat with Latest
		g. Add pswd_val Folder + exe_pswd_val.bat File
		h. Copy COMALL.SQL File
		i. Disable jobs (If Exists)
		j. Remove Parameters.dat File
		
	3. NTP Load Data
		a. Replace Setup.bat with Latest
		b. Update excute.bat files (Set Parameters)
		c. Add pswd_val Folder + exe_pswd_val.bat File
		d. Remove Parameters.dat File
		
	4. Migration Scripts
		a. Remove 0. User Creation
		b. Remove 11. Archival Migration