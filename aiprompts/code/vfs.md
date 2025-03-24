
create a module vfs_mail in @lib/vfs 
check the interface as defined in @lib/vfs/interface.v and @metadata.v 

see example how a vfs is made in @lib/vfs/vfs_local 

create the vfs to represent mail objects in @lib/circles/dbs/core/mail_db.v 

mailbox propery on the Email object defines the path in the vfs
this mailbox property can be e.g. Draft/something/somethingelse

in that dir show a subdir /id:
-  which show the Email as a json underneith the ${email.id}.json

in that dir show subdir /subject:
-  which show the Email as a json underneith the name_fix(${email.envelope.subject}.json

so basically we have 2 representations of the same mail in the vfs, both have the. json as content of the file








