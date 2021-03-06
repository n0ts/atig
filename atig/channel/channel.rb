#! /opt/local/bin/ruby -w
# -*- mode:ruby; coding:utf-8 -*-

module Atig
  module Channel
    class Channel
      def initialize(context, gateway, db)
        @db      = db
        @channel = gateway.channel channel_name, :handler=>self
        @channel.join_me

        db.statuses.listen do|entry|
          @channel.topic entry if entry.user.id == db.me.id
        end
      end
    end
  end
end
