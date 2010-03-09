One rule, no worries.

 - all resource routes are catched
 - no actions (aka collection/member) need to be added
 - no _url / _path / _hash helpers in global namespace
 - fallback to resources for edge-cases (e.g. nesting)

Install
=======
**No big testing done, the basics work, gimme feedback on what does not**

    script/plugins install git://github.com/grosser/restful_catch_all_route.git

Usage
=====
To enable resourceful routing add:
    # routes.rb
    map.restful_catch_all_route
    map.connect ':controller/:action/:id' # if you need it, place it behind

### Id formats
By default it accepts ids that are pure numbers, or contain a '-'.  
You can overwrite it by passing `:id => /my_rex/`

 - `/my_controller/1/edit` - works
 - `/my_controller/1-fancy-title/edit` - works
 - `/my_controller/fancy-title/edit` - works
 - `/my_controller/fancy_title/edit` - works NOT

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...