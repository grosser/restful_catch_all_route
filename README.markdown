<del>map.resources :user</del><br />
<del>map.resources :products, :member => {:goto => :get, :bar => :get}</del><br />
<del>map.resources :ads, :collection => {:search => :get, :preview => :get}</del><br />
<del>map.resources :lists, :member => {:something => :post}</del><br />
<del>map.resources :toys, :collection => {:foo => :put}</del><br />
<del>map.resources :sounds</del><br />
...<br/>
<b>map.restful_catch_all_route</b>

(For Rails 2 and 3)

 - REST like normal (/users <-> index+create, /users/1 <-> show+update+destroy, /users/1/edit, /users/new )
 - collection and members map automatically (/users/search, /users/1/add)
 - `_url` / `_path` / `_hash` helper free global namespace
 - fallback to `map.resources` for e.g. nested resources
 - [restful catch all route example app](http://github.com/grosser/restful_catch_all_route_example)

Install
=======

    script/plugins install git://github.com/grosser/restful_catch_all_route.git

    # config/routes.rb
    map.restful_catch_all_route

    namespace(:admin) do |admin|
      map.restful_catch_all_route  
    end

    # if you need REST-less fallback urls, they must be placed after restful catch all
    # map.connect ':controller/:action/:id'

Usage
=====

    # like normal:
    form_for @user
    link_to 'hey', @user
    polymorphic_url(@user)
    polymorphic_url([:admin, @user])

    # changed:
    link_to 'foo', new_users_path
    link_to 'edit foo', edit_user_path(user)

    # is now one of these ...
    link_to 'foo', '/users/new'
    link_to 'foo', :controller => 'users', :action => 'new'
    link_to 'foo', polymorphic_url(User, :action => :new)

    link_to 'edit foo', "/users/edit/#{user.id}"
    link_to 'edit foo', :controller => :users, :action => :edit, :id => user.id
    link_to 'edit foo', polymorphic_url(user, :action => :edit)


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