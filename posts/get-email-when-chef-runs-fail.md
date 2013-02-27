<!--
title: Get email when Chef runs fail
created: 27 February 2013 - 3:31 am
updated: 27 February 2013 - 4:31 am
publish: 5 March 2013
slug: chef-handlers
tags: coding, chef
-->

One of my favorite parts of [Jenkins][] is email notifications. You get email
both when a job fails, and when it goes back to being normal. Mimicing this
functionality in [Chef][] is a matter of using [exception and report handlers][]
to send you email when a run fails or finishes.

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
getting reporting information out of Chef.

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

          Net::SMTP.start(options[:server]) do |smtp|
            smtp.send_message message, from, to
          end
        end

        def unindent string
          first = string.scan /^\s*/
          first = first.min_by { |l| l.length }
          string.gsub /^#{first}/, ''
        end
      end
    end

## Installing your handler ##

The [chef_handler cookbook][] makes installing a custom handler easy.

    include_recipe 'chef_handler'

    handler_path = node['chef_handler']['handler_path']

    cookbook_file "#{handler_path}/send_email.rb" do
      source 'send_emal.rb'
    end

    chef_handler 'BeFrank::SendEmail' do
      source "#{handler_path}/send_email"
      action :enable
    end


[Jenkins]: http://jenkins-ci.org/ "Various (Jenkins CI): Jenkins is an extendable open source continuous integration server."
[Chef]: http://opscode.com/chef "Various (Opscode): Chef is an open-source automation platform built to address the hardest infrastructure challenges on the planet."
[exception and report handlers]: http://docs.opscode.com/essentials_handlers.html "Various (Opscode): About Exception and Report Handlers"
[chef_handler cookbook]: http://community.opscode.com/cookbooks/chef_handler "Various (Opscode): A cookbook for distributing and enabling Chef Execption and Report handlers"
