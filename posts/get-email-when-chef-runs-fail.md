<!--
title: Get email when Chef runs fail
created: 27 February 2013 - 3:31 am
updated: 2 March 2013 - 9:09 am
publish: 5 March 2013
slug: chef-handlers
tags: coding, chef
-->

One of my favorite parts of [Jenkins][] is email notifications. You get email
both when a job fails, and when it goes back to being normal. Mimicing this
functionality in [Chef][] is a matter of using [exception and report handlers][]
to send email when a run fails or finishes.

## Writing your own handler ##

Building a custom Chef hanlder is a matter of inheriting from the
`Chef::Handler` class and overriding the `report` method.

    module BeFrank
      class SendEmail < Chef::Handler
        def report
        end
      end
    end

Though really you want to get email sending working before you worry about
getting reporting information out of Chef. Because [good programmers Google][],
Jerod Santo gets credit for figuring out [how to send email][] and Gavin Kistner
gets credit for [unindenting HEREDOCs][].

    require 'net/smtp'

    module BeFrank
      class SendEmail < Chef::Handler
        def report
        end

        private

        def send_email options = {}
          options[:subject] ||= 'Hello from Chef'
          options[:body] ||= '...'
          options[:from] ||= 'chef@example.com'
          options[:from_alias] ||= 'Chef Client'
          options[:to] ||= 'you@example.com'
          options[:server] ||= 'localhost'

          from = options[:from]
          to = options[:to]

          message = <<-EOM
          From: #{options[:from_alias]} <#{from}>
          To: #{to}
          Subject: #{options[:subject]}

          #{options[:body]}
          EOM

          message = unindent message

          ::Net::SMTP.start(options[:server]) do |smtp|
            smtp.send_message message, from, to
          end
        end

        def unindent string
          first = string[/\A\s*/]
          string.gsub /^#{first}/, ''
        end
      end
    end

If Chef is queued to run every couple of minutes, broken nodes will start
to spam you. Spam sucks. To avoid it, hash the email and only send it if
it's different from the last email you sent. You can use Chef's cache to
store your checksum.

    require 'net/smtp'
    require 'digest'

    module BeFrank
      class SendEmail < Chef::Handler
        def report
        end

        private

        def send_new_email data = {}
          cache = Chef::Config[:file_cache_path]
          cache = ::File.join cache, 'last_run.digest'

          last_digest = nil
          if ::File.exists? cache
            last_digest = ::File.read cache
          end

          # This works around an issue in Ruby 1.8
          # where Hashes don't enumerate their values
          # in a guaranteed order.
          data = data.keys.sort.map do |k|
            [k, data[k]]
          end

          digest = ::Digest::SHA256.hexdigest data.to_s
          ::File.open(cache, 'w') do |io|
            io << digest
          end

          if digest != last_digest
            send_email ::Hash[data]
          end
        end

        # You don't really want to reread all that
        # email handling code, do you?
      end
    end

Chef provides a `failed?` method to check the status of the run. Grab the
exception and backtrace from a failed run and email them out. If the run's
successful, send out a message saying everything's okay.

    require 'net/smtp'
    require 'digest'
    require 'time'

    module BeFrank
      class SendEmail < Chef::Handler
        def report
          now = ::Time.now.utc.iso8601
          name = node.name

          subject = "Good Chef run on #{name} @ #{now}"
          message = "It's all good."

          if failed?
            subject = "Bad Chef run on #{name} @ #{now}"
            message = [run_status.formatted_exception]
            message += ::Array(backtrace).join("\n")
          end

          send_new_email(
            :subject => subject,
            :body => message
          )
        end

        private

        # You don't really want to reread all that
        # email hashing and handling code, do you?
      end
    end

Did you notice the abuse of explict naming for core Ruby classes? Some of the
Chef code (like the [file resource class][]) conflicts with the naming for
core Ruby classes during a run. Prefixing them with `::` avoids those errors.

## Installing your handler ##

The [chef_handler cookbook][] makes installing your custom handler easy.
Write up a new default `email_handler` recipe, drop your email handling
code in as a [cookbook file resource][], and you're good to go.

    include_recipe 'chef_handler'

    handler_path = node['chef_handler']['handler_path']
    handler = ::File.join handler_path, 'send_email'

    cookbook_file "#{handler}.rb" do
      source 'send_emal.rb'
    end

    chef_handler 'BeFrank::SendEmail' do
      source handler
      action :enable
    end

Just include your `email_handler` cookbook in your base role to start getting
email messages about the status of Chef runs.

## Taking things further ##

Notifications are useful for telling you when new nodes successfully come
online, and when existing nodes break. Now that you know how to do it for email,
you can push Chef run notifications into [CloudWatch][], [Graphite][], or your
monitoring solution of choice.


[Jenkins]: http://jenkins-ci.org/ "Various (Jenkins CI): Jenkins is an extendable open source continuous integration server."
[Chef]: http://opscode.com/chef "Various (Opscode): Chef is an open-source automation platform built to address the hardest infrastructure challenges on the planet."
[exception and report handlers]: http://docs.opscode.com/essentials_handlers.html "Various (Opscode): About Exception and Report Handlers"
[good programmers Google]: http://blog.framebase.io/post/43973262180/the-best-programmers-are-the-quickest-to-google "Vu Tran (Framebase.io): The best programmers are the quickest to Google"
[how to send email]: http://blog.jerodsanto.net/2009/02/a-simple-ruby-method-to-send-emai/ "Jerod Santo: A simple Ruby method to send email"
[unindenting HEREDOCs]: http://stackoverflow.com/questions/3772864/how-do-i-remove-leading-whitespace-chars-from-ruby-heredoc "Various (Stack Overflow): How do I remove whitespace chars from Ruby HEREDOC?"
[file resource class]: https://github.com/opscode/chef/blob/master/lib/chef/resource/file.rb "Opscode (GitHub): Raw code for the Chef::Resource::File class"
[chef_handler cookbook]: http://community.opscode.com/cookbooks/chef_handler "Various (Opscode): A cookbook for distributing and enabling Chef Execption and Report handlers"
[cookbook file resource]: http://docs.opscode.com/chef/resources.html#cookbook-file "Various (Opscode): The cookbook_file resource is used to transfer files from the cookbook to the host."
[CloudWatch]: http://aws.amazon.com/cloudwatch/ "Various (Amazon): Amazon CloudWatch provides monitoring for AWS cloud resources and the applications customers run on AWS."
[Graphite]: http://graphite.wikidot.com/ "Various (Graphite): Graphite is a highly scalable realtime graphing system."
