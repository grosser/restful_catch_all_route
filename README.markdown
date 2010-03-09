One rule, no worries. (only Rails 2.3 for now...)

 - resources like normal (get:show, put:update, delete:destroy, post:create, edit, new, index, etc.)
 - no resources need to be added
 - no actions (aka collection/member) need to be added
 - no _url / _path / _hash helpers in global namespace
 - you can always add normal resources for edge-cases (e.g. nesting)

Install
=======

    script/plugins install git://github.com/grosser/restful_catch_all_route.git

    # config/routes.rb
    map.restful_catch_all_route

    # if you need it, it must be placed after restful catch all
    # map.connect ':controller/:action/:id'

Usage
=====

    Before:
      link_to 'foo', new_bar_path

    After:
      link_to 'foo', '/bar/new'
      link_to 'foo', :controller => 'bar', :action => 'new'

### Id formats
By default it accepts ids that are pure numbers, or contain a '-'.  
You can overwrite it by passing `:id => /my_rex/`

 - `/my_controller/1/edit` - works
 - `/my_controller/1-fancy-title/edit` - works
 - `/my_controller/fancy-title/edit` - works
 - `/my_controller/fancy_title/edit` - works NOT

Performance
===========
Rails 2.3.5 with 50 resources 100_000 times

<table>
<tr><td></td><td>Recognition</td><td>Generation</td><td>RAM</td><td>Helpers</td></tr>
<tr><td>catch all</td><td>9.1s</td><td>6.6</td><td></td><td>200+ (1</td></tr>
<tr><td>resources</td><td>68.2s</td><td>9.5</td><td>+9MB</td><td>0</td></tr>
</table>
(1 `50 * (xxx_path + xxxs_path + new_xxx_path + edit_xxx_path + custom members)`

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...