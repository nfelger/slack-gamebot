module SlackGamebot
  module Commands
    class Record < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        #challenger = ::User.find_create_or_update_by_slack_id!(client, data.user)
        #arguments = match['expression'].split.reject(&:blank?) if match.names.include?('expression')
        #arguments ||= []
        client.say(channel: data.channel, text: match.inspect, gif: 'noted')
        logger.info "record: #{data.user} - #{}"
      end
    end
  end
end
