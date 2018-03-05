=== Plugin Name ===
Contributors: rilwis
Donate link: http://www.deluxeblogtips.com/donate
Tags: pm, private message, private messages, message, messages
Requires at least: 3.0
Tested up to: 3.4.2
Stable tag: 2.1.10

The Private Messages For WordPress allows users of WordPress blog send private messages (PM) to each other, just like in a forum.

== Description ==

[Project Page](http://www.deluxeblogtips.com/private-messages-for-wordpress) | [Support](http://www.deluxeblogtips.com/support) | [Donate](http://www.deluxeblogtips.com/donate)

*The Private Messages For WordPress allows users of WordPress blog send private messages (PM) to each other*.  Users will have their own inbox and outbox. Administrators of blog can  control total numbers of items in mailbox of each user group (Administrator, Editor, Author, Constributor and Subscriber).

Also, an email is sent to user when a new PM is received. Email template is full-controlled.

**Credits:**

- **OP351.net**: for internationalization idea and Portuguese translation
- <a href="http://matthiaskretschmann.com/" rel="nofollow">**Matthias Kretschmann**</a>: for icon design and German translation
- **Paperboy**: for Swedish translation
- **Ivo Hajny**: for Czech translation
- <a href="http://liryk.lautre.net/" rel="nofollow">**liryk**</a>: for French translation
- **Huseyin Cahid Dogan**: for Turkish translation
- **masya2000**: for Russian translation
- **Christian**: for Danish translation
- <a href="http://pc.de/" rel="nofollow">**Marcis Gasuns**</a>: for Belorussian translation
- **Rteelen**: For Dutch translation3
- **Mostafa**: for Persian translation
- <a href="http://www.enricodeleo.com/" rel="nofollow">**Enrico**</a>: for Italian translation
- <a href="http://webhostinggeeks.com/" rel="nofollow">**Web Hosting Geeks**</a>: for Romanian translation
- <a href="http://teusoft.com" rel="nofollow">**Javier Santos**</a>: for Spanish translation

== Installation ==

1. Unzip downloaded file and upload the plugin folder to the `/wp-content/plugins/` directory
1. Activate the plugin through the 'Plugins' menu in WordPress
1. Set the number of PM for each user role, and the email template in the plugin option page (or you can use the default option)
1. Set how to choose recipient: from dropdown list or auto suggest from user input
1. Now you will see a new menu `Messages` in the left. Just select `Send` for sending PM or check the `Inbox` and `Outbox`.

== Frequently Asked Questions ==

= How can I set the number of private messages for each user? =

You can set number of PM for only user role (group): Administrator, Editor, Author, Contributor, Subscriber. The option is in the plugin option page (`Settings` > `Private Messages`)

= How can I delete my old PM? =

Go to `Inbox` or `Outbox`, and click the link `Delete` after each message to delete it. Or you can check multiple messages and select `Delete` action from the dropdown box.

= How can I reply to sender? =

Just click the `Reply` link below the message in your `Inbox`.

= What can I do if I exceed my limit? =

You can delete your old PM (see previous question) or ask admin to increase the mailbox quota.

= How can use this plugin in the front-end =

1. Copy the file `pm4wp-template.php` into your theme folder
1. Create a page, choose Private Messages as a page template (in the right panel)
1. Check it out in the front-page

Note: the template file is just the backbone, you should modify it to fit your template.

== Screenshots ==

1. Inbox
2. Outbox
3. Send page
4. Option page

== Changelog ==

= 2.1.10 =
* Bug fix: Send to multiple recipient
* Improvement: Add hooks to pages
* Improvement: Better retrieve user list

= 2.1.8 =

* Bug fix: Load translation

= 2.1.7 =

* Improvement: Show notification in admin bar
* Improvement: Add original message when reply

= 2.1.6 =

* Add Spanish translation

= 2.1.5 =

* Add Romanian translation

= 2.1.4 =

* Add Hungarian translation, thank Jazoja
* Fix some un-indexed errors
* Fix some deprecated functions
* Fix link in email
* Delete table and option only when uninstall

= 2.1.3 =

* Add Italian translation, thank Enrico

= 2.1.2 =

* Update French translation, thank liryk

= 2.1.1 =

* Add some languages

= 2.1 =

* Allow send PM to multiple recipients
* Fix bug not display sender name in email
* Allow only some HTML tags in email notification
* Create a page template for front-end usage

= 2.0 =

* Add Czech language by Ivo Hajny. Thank you.
* Add Danish language by Christian. Thank you.
* Add French language by Cyril. Thank you. (I received 3 translation of French from Cyril, Olivier (Misterco), and MTN Concept. I'm not sure which is the best!)
* Fix 1 missing of translation, reported by Cyril.
* Add email notification when receive new PM.
* Fix timezone error, reported by mcmeta09@nave.com
* Add sidebar widget for displaying notifications and new PMs.

= 1.6 =
* Fix empty recipient, subject and content when send PM (bug reported by Andrey Moiseyev).
* Add Turkish language by H\u00FCseyin Cahid Do\u011Fan. Thank you.

= 1.5 =
* Fix URL of plugin pages.
* Add Russian language by masya2000. Thank you.

= 1.4 =
* Fix output escape bug.
* Fix some forgotten internationalization strings.
* Add German translation by Matthias Kretschmann (http://matthiaskretschmann.com). Thank you.
* Add Swedish translation by Paperboy. Thank you.

= 1.3 =
* Add new icon, designed by Matthias Kretschmann (http://matthiaskretschmann.com). Thank you.
* Fix for menu internationalization.
* Add option to choose recipient from dropdown list or auto suggest from user input.

= 1.2 =
* Internationalization & slight code improvements by OP351.net (http://op351.net). Thank you.
* Add Portuguese translation by OP351.net.

= 1.1 =
* Create list of users for easy choosing when send PM.

= 1.0 =
* Core function of plugin.
