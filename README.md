# ansible-vault-string-helper

Easily encrypt strings in ansible var files in a git friendly way.

## What problem is this sorcery solving ?

This sourcery (typo intended) is about helping you to fix `ansible-vault`.
`ansible-vault` will garble any given file in such a way that it's not useful for
team work with git.

Here is an example:

```
grumpycoder@machine:~/Software/devoops-project $ cat merf.yml
signaling:
  session:
    hash_key: bla
grumpycoder@machine:~/Software/devoops-project $ ansible-vault encrypt --ask-vault-password merf.yml
New Vault password:
Confirm New Vault password:
Encryption successful
grumpycoder@machine:~/ $ cat merf.yml
$ANSIBLE_VAULT;1.1;AES256
30663764623732313964316265646364356463366130666239376231393235616564343733306633
3231623231613331353837393232313464383534306632330a303338326237306432613131313932
30656334636563666236623435666531343331393133613433623735306339383936626566343865
3332656366393331630a306139643736383531383034346632353538373764393933343966613566
65333131303862623836333931333831623138623562633761396631326137633032303964656362
3138373333316132656433323562643666323165616164656339
```
The file is now a complete blob (encrypted with the password 123456). Further changes
to this file will result in another blob, in such a way that it's impossible to track
changes with git.
One can use:

```
grumpycoder@machine:~/Software/devoops-project $ ansible-vault encrypt_string bla
New Vault password:
Confirm New Vault password:
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          38393665353765373337623861336234373464343338353138313764346130376237396166646335
          6531613130643139623737623234316431353363326231640a396165346264396562303831313437
          35323437313431396363613362366533363966376263316331616236363331373835636266376564
          6433636634323733350a333339376637323961656436383239663237656333376461376562643436
          3437
Encryption successful
```

Now, you need to go and copy this value and stick it in the file. But there is no easy
way to peek into values in the files.

## The solution
 
Well, it is much nicer if one can only encrypt the `hash_key` in the above example, and do
it in one command!
Here is how:
```
# someone committed a clear text password. Bad boy! But we can help them!
grumpycoder@machine:~/Software/devoops-project $ cat merf.yml
signaling:
  session:
    hash_key: bla
# I used 123456123456 as the vault password
grumpycoder@machine:~/Software/devoops-project $ ./ansible-vault-string.sh --encrypt merf.yml signaling.session.hash_key glory
New Vault password:
Confirm New Vault password:
grumpycoder@machine:~/Software/devoops-project $ cat merf.yml
signaling:
  session:
    hash_key: !vault |
      $ANSIBLE_VAULT;1.1;AES256
      30666235316533336465636537323037313839623037323436353763383566613863656335656266
      3162343732666235616462323638346437643932646632370a656238656132616633396435393534
      62646265646439373232313635396634323266353966623739363130306436313337623336353033
      6464343662313733660a326237323761323538343864393163656466386332363231306539383965
      3465
grumpycoder@machine:~/Software/devoops-project $ ./ansible-vault-string.sh --decrypt merf.yml signaling.session.hash_key
Vault password:
(This will open a pager and will show you glory)
```

And off you go, replace all your clear text passwords with something which is a bit harder to hack.

### Honestly, this repository should not exist

This should be the official CLI in `ansible-vault`. But since `ansible` is a terrible
(and very much popular) hack, it does not have it. I could pull my sleeves and hack
the Python code, but there is no guarantee upstream will accept my PR. If you think
this repository is justified open an issue in `anisble` Github's repository, if enough
people will comment on such a ticket maybe upstream will fix it (if you really bothered,
and did create such an issue, let me know. I will link it here).
Alternatively, if someone is willing to sponsor such a work, you can contact me directly.

If this was added in some form to ansible, please let me know!

### Similar tools

[SOPS][1] A tool from the guys in mozilla to encrypt values in yaml, json and more formats. 
Good amount of work done GO. Makes me wonder if I hit the same nerve as Mozilla Guys did.
Obviously, they have more resources to waste on solving a similar problem with a bigger hammer.


[1]: https://github.com/mozilla/sops
