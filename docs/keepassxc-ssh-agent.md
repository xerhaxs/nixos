# SSH keys in KeePassXC

KeePassXC can store SSH private keys as attachments of database entries and load them into the running ssh-agent when the database is unlocked, and remove them again when it locks ([documentation](https://github.com/keepassxreboot/keepassxc/blob/develop/docs/topics/SSHAgent.adoc)).

## Setup in this repository

- `homeModules/applications/tools/keepassxc.nix`: `SSHAgent.Enable = true`, and since now an ssh-agent user service (`services.ssh-agent`) with `SSH_AUTH_SOCK` exported to the graphical session, so KeePassXC finds the agent. Before this change no agent was running, the integration had nothing to talk to.
- `homeModules/base/ssh.nix`: for the own servers only `~/.ssh/id_ed25519.pub` is offered (`IdentitiesOnly`), the private key may stay only in KeePassXC. The servers allow only 3 authentication attempts, an agent with many keys would fail otherwise.

## Steps (once)

1. In KeePassXC create an entry "SSH id_ed25519", attach `~/.ssh/id_ed25519` (Advanced > Attachments), put the key passphrase into the password field.
2. Entry > SSH Agent: "Add key to agent when database is opened/unlocked", "Remove key from agent when database is closed/locked", optional "Require user confirmation when this key is used" (every use asks; needs `ssh-askpass`, KDE has ksshaskpass) and a lifetime.
3. Check: unlock the database, `ssh-add -l` lists the key; lock it, the list is empty.
4. Keep `~/.ssh/id_ed25519.pub` on disk, delete the private key file from `~/.ssh` (it stays in the database and its backups).

## Does it improve security?

Yes, moderately:

- The private key no longer lies on disk; it is protected by the database (Argon2 + key file) instead of only an ssh key passphrase, and it is part of the KeePassXC backups.
- The key is only usable while the database is unlocked; locking the screen locks the database (`LockDatabaseScreenLock = true`) and removes the key from the agent.
- The confirmation option shows every use of the key, a malicious process cannot use the agent silently.

It does not protect against malware running as your user while the database is unlocked (it can use the agent, and without confirmation silently). The strongest option is a hardware key (FIDO2 `ed25519-sk` keys on a YubiKey/Nitrokey): the private key never leaves the token and every use needs a touch. Both can be combined: the `-sk` key handle can also be stored in KeePassXC.
