# Functions

## getMailboxes(domain)
Returns a list of all the mailboxes belonging to a domain.

## getAliases(id)
Fetch the alias `id`. If left empty it fetches all the aliases on the server.

## getDomainAliases(mailbox)
Fetch all the aliases for a specific mailbox.

## addAlias(aliasEmail, mailbox)
Add the aliasEmail to the mailbox.

## getBlacklist(domain)
Fetch the black listed emails for the domain as a json array.

## addBlacklist(domain, email)
Add the email to the blacklist of the domain.

## addBlacklistList(domain, emails)
Add a whole list of email addresses to the domain. These email addresses should be added to the $emails array in the `aliases.rb` file as follows:

```
$emails = [
    "blacklisted@example.com",
    "lacklisted@example.com"
]
```


## addAliasesFromHash(aliasHash)
For if you have a lot of aliases to add.  The alias expansions from $aliases are added to mailcow. The format of the aliases hash is as follows:

```
$aliases = {
"someone@example.com" => "you@example.com",
"someone_else@example.com" => "you@example.com",
"another_alias@example.com" => "colleague@example.com"
}
```
The alias `someone@example.com` is delivered to the mailbox `you@example.com`.


## getDKIM(domain)
I use this in combination with the API from my DNS provider. I extract the DKIM from mailcow and upload it in one go (in another script).