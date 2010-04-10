#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

module Atig
  module Command
    module Info
      def user(db, api, name, &f)
        if user = db.followings.find_by_screen_name(name) then
          f.call user
        else
          api.delay(0) do|t|
            user = t.get "users/show",:screen_name=>name
            f.call user
          end
        end
      end

      def status(db, api, id, &f)
        if status = db.statuses.find_by_id(id) then
          f.call status
        else
          api.delay(0) do|t|
            status = t.get "statuses/show/#{id}"
            db.transaction do|d|
              d.statuses.add :status => status, :user => status.user, :source => :thread
              f.call db.statuses.find_by_id(id)
            end
          end
        end
      end

      module_function :user,:status
    end
  end
end