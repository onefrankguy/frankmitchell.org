<!--
title: How to do one time setup with Chef
created: 5 August 2014 - 7:44 am
updated: 5 August 2014 - 7:44 am
publish: 5 August 2014
slug: chef-idempotent
tags: coding, chef
-->


    if [ ! -f lockfile ];
    then
      touch lockfile
      initdb -D data
    fi;


    execute 'initdb' do
      command 'touch lockfile && initdb -D data'
      not_if 'test -f lockfile'
    end


    execute 'initdb' do
      command 'touch lockfile && initdb -D data'
      not_if do
        ::File.exists? 'lockfile'
      end
    end


    cookbook_file 'setup.sh' do
      action :create_if_missing
      notifies :run, 'execute[initdb]', :immediately
    end

    execute 'initdb' do
      command 'setup.sh'
      action :nothing
    end
