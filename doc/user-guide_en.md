# Wor-Prof

Wor-prof (Wprof) is a gem for Ruby On Rails which its only purpose is to measure a RoR app's performance through a profile with different times of response. In order to accomplish that, Wprof uses ActiveSupport::Notifications (available in Rails since v4.0.2) to capture every action from his controllers. However, there's more. when using httparty in your project, you can capture every done request to external services. Do you have one or two methods that would like to know how long they take to execute? With Wprof you can find out.

Then, every data obtained can be reported in several ways, choose one from the Rails logger: database file, CSV text or go ahead and do a Post request wherever you want... Do it both synchronously or asynchronously.

---

## Let's begin.

The first step is the gem install (of course) and the way to do it is well known. However, just in case, you'll find the steps to follow next.

### Installation 

Add the next line to the gemfile from your Rails application:

```ruby
gem 'wor-prof'
```

execute:
```bash
$ bundle install
```

And then, execute:
```bash
$ rails generate wprof (or copy initializer by yourself)
```
**That's it!!** At server execution, WProf immediately begins to work with default settings, so you won't need to configure anything if it matches with your needs, otherwise you can check **Available Settings**.

`If you don't run wprof generator, you must be initialized Wprof. For do this, add the next line into any rails initializers`

```ruby
WProf::Configuration.initiate_wprof
```

`We highest recommended execute "rails generate wprof"`

---

## Register Types and how they works.

As register types, Wprof counts with the following.

* Controllers: every request realized to Rails' App that is handled by a Controller. (this is a default setting and cannot be disabled)
* HTTParty: every time an HTTParty method is involved.
* Own methods: an array of methods can be defined to be captured.
``Only "controllers" are automatically profiled by just adding the gem, every other one will need an extra configuration or operation.``

### HTTparty

HTTParty is a popular tool for Ruby that allows to easily make HTTP's requests.
If you're not used to the gem I recommend you to read more information in its repository, right [here!](https://github.com/jnunemaker/httparty)

In order to profile the requests made by  HTTParty, you must include Wprof right after Httparty. This is:

```ruby
class FooClass
    include HTTParty
    include Wprof
```
What that does mean? Wprof make a wrapper over every called method as class methods, waits for the response and captures some of the needed data to generate the profile. This is why you **must include the module right after HTTParty**... Otherwise, it would simply not work.

By default, WProf defines the methods that are commonly used to generate a request (Get, Put, Delete, Post), however you can define or exclude some of that list. It's **strongly recommended not to add** HTTParty's methods without being completely certain that the result is what WProf will try to capture (See 'captured Data' to know which are they)

### Own methods

Sometimes it may result useful to know how much an specific method is taking to execute, to this end Wor-prof can help you out.

There are two steps to accomplish that.

1. Prepare an array of methods which you want to trace (check configuration section: "custom_methods")
2. Include WProf to that method's class

Done, with this WProf will be registering the execution time of said method every time is being called and then it will report it.

---

## Available Configurations.

WProf contains a list of default settings which can all be altered by others availables as user's preferences demands. In order to do that, create a file in 'config/initializers' (RailsApp.Root >> config >> initializers >> wprof.rb). Inside, you must define the following configuration:

```ruby
WProf::Configuration.configure do |config|
  config.db_runtime = true
  config.reporter_type = 'FILE'
end
```
> In case of not correctly configuring an option or just skip it, the value would be default.

To avoid this configuration manually using the **configuration generator** with the command "rails generate wprof" (see generator section).

Following the complete list of available settings and their meaning.

### config.db_runtime
Sets whether it shows or not the data "db_runtime" inside the report.

> Possible values: true o false

> Default: true

### config.reporter_type 
Sets report type, meaning, how to show the obtained data. There are currently 4 available types, see "Reports" section for more information.

> Possible values: LOGGER, FILE, DATABASE, EXTERNAL

> Default: LOGGER

### config.csv_type
When the report is defined as a CSV file there are two ways of generate it.
* **MIX:** generates one CSV file where every data captured by WProf is saved. This file only contains 2 columns: in the first one is the field and in the second one the data.
* **SPLIT:** Divides storage in three different files, one for each record type. This significantly improves reading since every field is held as the file's header and the data in rows is split by comma... As it should be, of course... Why mix then?, I don't know, it could be useful for someone!
> Possible values: MIX, SPLIT.
> Default: SPLIT

### config.async
Sets whether the report is being generated sinchronously or not. **Take note: asynchronous mode requires extra steps, see "asynchronism" section for more information.**
> Possible values: false, true
> Default: false

### config.httparty_methods_to_trace
HTTParty's method captured by WProf. By default, more common ones are set and it's recommended not to modify.
This being said, there's no problem in taking out some of the array, however take special care in adding HTTParty's methods which doesn't return an http request.
> Possible values: what you want and need, must be an **array of strings**.
> Default: ['get', 'put', 'delete', 'post']

### config.external_url
In case you configure reporter_type as External, you must indicate the URL which will receive the HTTP petition.
> Possible values: any string that corresponds to an URL. Example: 'http://example-url/reporter'
> Default: nil

### config.external_headers
To add a header to the http request ("external" report type), you must define it in this setting. This must be a **HASH of RUBY**, exactly as HTTParty expects (internally Wprof uses HTTParty to send a request). An example would be:

``` ruby
config.external_headers = { headers: {'User-Agent' => 'Httparty'}}
```
> Possible : Any valid hash, must respect primary key as "headers" (check example below)
> Default: nil

### config.custom_methods
If you want to capture response times of an specific method inside a class, it's not enough including the module, you'll need to indicate WProf exactly which is the one it has to capture.
This list of methods must be contained in this option in a **array of Ruby** and it has to be strings.
Example:
``` ruby
config.custom_methods = [ 'my_great_method' ]
```
> Possible values: any method's name in string format, within an array.  Default: nil

### config.file_path

When "FILE" is used as an output, this option allows you to choose the files destination. This must be a valid route, as string, with reading permission for Rails and also be a folder.
Example: 
``` ruby
config.file_path = '/home/mcolombo/examplefolder'
```
> Possible values: any string that correctly represents a PATH to a directory.
> Default: Rails.root is used, so, root is Rails application.

### config.disable_wprof

Enable or Disable Wprof when this single line.

> Possible values: true or false.
> Default: false.

---

## Generators.

WProf has two Rails generators availables.

---

### Configuration file Generator.

To begin to modify options from available settings, you must create a config file inside the 'config/initializers' (as mentioned in "available configurations" section). To avoid unnecessary steps and possible mistakes in the well known dangerous 'copy/paste', you can generate this file as a template with the following Rails command:

```
rails generate wprof
```
This generates a model of the configuration's file with all the available options seen in "available configurations" section. It's necessary for initializer Wprof.

### Data Model Generator

An available option to report captured information is the same database Rails uses, the problem is, this requires defining the model. This generator will create all of the migration files and the models for using this option without having to worry for anything else.
```
rails generate wprof_model
```
This will generate the migration files and the models (even controllers in case you want to handle them!) 
**Remember: in order to models be available in the case you still must run the migration.**
```
rails db:migrate
```

---

## Captured Data.

Data captured and reported by WProf vary depending on which record they come, although, all of them share some base data.

### Base data (common to all)

* **transaction_id:** unique identifier for each transaction. This field is vital due to HTTParty's records and methods share this same identifier with the request that triggered this execution, allowing a complete execution trace of each one of them.
* **total_time:** Total execution time registered (in milliseconds).
* **start_dt:** Date and time field when register began.
* **end_dt:** Date and time field when register ended.

### Unique for the controller.

* **code:** Response code sensed by the controller (Status), eg. 200, 404, etc.
* **controller:** Controller that handled the request.
* **url:** Endpoint that received the petition.
* **db_runtime:** total time when it was absorbed by the database (included in total_time).

### Unique for the services (Httparty).

* **code:** Response code received (Status), eg. 200, 404, etc.
* **service_hostname:** Hostname of service.
* **request_uri:** Uri of endpoint.

### Unique for services (Httparty).

* **method:** measured method's name.

---

## Reports.

Destination of the data, once is captured and processed, varies in order of user’s preferences Wor-Prof offers the following destinations for the information:
* **LOGGER:** Uses Rails.logger to show the information.
* **FILE:** Saves the info in one or several text files, split by comma (csv)
* **DATABASE:** Saves obtained data in the same database used by Rails (requires model preparation, see generator/s of data model)
* **EXTERNAL:** Does a POST petition with the data sended in the body in a JSON format (requires additional configuration)

> "Logger" as well as "File" don’t need additional configuration to work, however “Database” and “External” require some previous step.

### Database Reporter

For **DATABASE** is necessary to generate a schema that allows information storage. To accomplish this, we provide a generator, however, if you want to manually generate WProf you need the following models (Migration files are exposed).

> Modelo: WprofController
``` ruby
class CreateWprofControllers < ActiveRecord::Migration[5.0]
  def change
    create_table :wprof_controllers do |t|
      t.string :transaction_id
      t.float :total_time
      t.datetime :start_dt
      t.datetime :end_dt
      t.integer :code
      t.string :controller
      t.string :url
      t.float :db_runtime

      t.timestamps
    end
    add_index :wprof_controllers, :transaction_id
    add_index :wprof_controllers, :code
    add_index :wprof_controllers, :url
  end
end
```
> Modelo: WprofService
``` ruby
class CreateWprofServices < ActiveRecord::Migration[5.0]
  def change
    create_table :wprof_services do |t|
      t.string :transaction_id
      t.float :total_time
      t.datetime :start_dt
      t.datetime :end_dt
      t.integer :code
      t.string :service_hostname
      t.string :request_uri

      t.timestamps
    end
    add_index :wprof_services, :transaction_id
    add_index :wprof_services, :code
    add_index :wprof_services, :service_hostname
    add_index :wprof_services, :request_uri
  end
end
```
> Modelo: WprofMethod
``` ruby
class CreateWprofMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :wprof_methods do |t|
      t.string :transaction_id
      t.float :total_time
      t.datetime :start_dt
      t.datetime :end_dt
      t.string :method

      t.timestamps
    end
    add_index :wprof_methods, :transaction_id
    add_index :wprof_methods, :method
  end
end
```

### External Request Reporter.
An option is sending data by HTTP wherever you want. Data obtained by Wprof will be sended in the body as JSON format. In order for this to work well it’s **necessary to configure destination’s URL**. Petition generated is POST and, when needed, you can configure the necessary HEADERS. If the URL is not configured, petition won’t be sended.
The options to be set are: external_url and external_headers. See Configurations section for more information.

---

## Asynchronism.

WProf by default reports all the information **synchronous**, although it’s possible to configure the tool in order to do this process **asynchronous**. To achieve this, you must first activate the option through config field "config.async = true", however this is not enough. For all of the report be made asynchronous, you must have functional and operational **Sidekiq**, since WProf uses it to that purpose. If you’re not familiar with the tool, you could give it a look to its [repository by clicking here!.](https://github.com/mperham/sidekiq).

---

## Handled errors.

Any error among the capture and report of the information **MUSTN’T** interrupt the normal functioning of your Rails application. If this is the case, please report it. During the execution, could show up two errors in application’s logger.

```WProf ERROR when try parsing service response:``` This error may appear if HTTParty wouldn’t be able to capture some data.

```An error was raised when WProf tried to send data to reporter:``` This is the most common error and it will appear if the data sending to the selected destination (meaning Logger, Database, File o External) has failed.

---