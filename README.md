# PowerShell Script to Detect Stopped Services and Send an Email
Automatically detect if any service has stopped and send an alert email.

## Important Operational Point

For Windows Active Directory Domain Controller (or any computer with a Domain Admin), some services are more important for the health of the organization's domain, authentication, replication, DNS resolution and directory services.

**For Example**

| **Service Display Name**             | **Service Name**    | **Purpose**                                              |
| :----------------------------------- | :------------------ | :------------------------------------------------------- |
| **Active Directory Domain Services** | `NTDS`              | Core AD DS database and directory service.               |
| **Kerberos Key Distribution Center** | `kdc`               | Handles Kerberos ticket requests for authentication.     |
| **Intersite Messaging**              | `IsmServ`           | Manages AD replication over SMTP (if configured).        |
| **DNS Server**                       | `DNS`               | DNS resolution for the domain and client computers.      |
| **Netlogon**                         | `Netlogon`          | Authenticates users and maintains secure channel to DCs. |
| **Windows Time**                     | `W32Time`           | Time synchronization service critical for Kerberos.      |
| **DFS Replication**                  | `DFSR`              | Replicates SYSVOL and other DFS folders.                 |
| **Remote Procedure Call (RPC)**      | `RPCSS`             | Core Windows service for interprocess communication.     |
| **Server**                           | `LanmanServer`      | Enables file, print, and named pipe sharing.             |
| **Workstation**                      | `LanmanWorkstation` | Allows the computer to connect to Windows shares.        |
| **TCP/IP NetBIOS Helper**            | `lmhosts`           | Supports NetBIOS name resolution.                        |
| **Windows Event Log**                | `EventLog`          | Manages event log messages.                              |

**This PowerShell script will check;**
For critical services — if any of them stopped, it will trigger a high-severity alert.
It will keep monitoring other services to detect unexpectedly stopped services.
Script will log critical and non-critical categories clearly and highlight in the email body.
It will keep a clean, organized email and log structure.
