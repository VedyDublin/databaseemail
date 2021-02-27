
/*To get notification or alert from the DB Instance, Database mail is the feature that will help here. 
Database mail will send notifications when any alerts occurs or when jobs fails/success depends on configuration. 

In below article I will show, how to configure Database mail using T-SQL scripts. */

--First of all it’ll need to enable the Database mail on Instance:

sp_configure 'show advanced options', 1;  

GO
Reconfigure;  
GO  
sp_configure 'Database Mail XPs', 1;  

GO
Reconfigure  
GO  

--Create Profile for the database mail: 

Execute msdb.dbo.sysmail_add_profile_sp
       @profile_name = 'ProfileName',
       @description = 'Profile to send Automated mail notification'
GO

--Create mail account for the Database mail:

Execute msdb.dbo.sysmail_add_account_sp
@account_name = 'AccountName',
@description = 'Account for sending Automated DBA Notifications',
@email_address = 'youremail@domain.com',
@mailserver_name = 'smtp.domain.com'
GO

--Add account to the profile:

Execute msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'ProfileName',
    @account_name = 'AccountName',
    @sequence_number = 1
GO
--To make profile public, default
Execute msdb.dbo.sysmail_add_principalprofile_sp
@principal_name='Guest',
@profile_name='ProfileName', 
@is_default=1
GO

--Sending a Test Mail to verify the mail configuration

Execute msdb.dbo.sp_send_dbmail
@profile_name = 'ProfileName',
@recipients = 'EmailId@domain.com',
@body = 'This is Database test Mail.',
@subject = 'Database Email Testing'


--Note : Here I have used AccountName , ProfileName & dummy domain for Example. Please use your own domain and SMTP address, your choice of AccountName & ProfileName.