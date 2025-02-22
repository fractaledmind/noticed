module Noticed
  module DeliveryMethods
    class ActionCable < Base
      def deliver
        channel.broadcast_to stream, format
      end

      private

      def format
        if (method = options[:format])
          notifier.send(method)
        else
          notifier.params
        end
      end

      def channel
        @channel ||= begin
          value = options[:channel]
          case value
          when String
            value.constantize
          when Symbol
            notifier.send(value)
          when Class
            value
          else
            Noticed::NotificationChannel
          end
        end
      end

      def stream
        value = options[:stream]
        case value
        when String
          value
        when Symbol
          notification.send(value)
        else
          recipient
        end
      end
    end
  end
end
