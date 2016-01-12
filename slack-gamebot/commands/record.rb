module SlackGamebot
  module Commands
    class Record < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        arguments = match['expression'].split.reject(&:blank?) if match.names.include?('expression')
        arguments ||= []
        verbs = ['beat', 'crushed', 'destroyed', 'humiliated', 'obliterated', 'defeated', 'conquered', 'vanquished', 'trounced', 'routed', 'overwhelmed', 'quashed', 'clobbered', 'pwned']
        unless (arguments.size == 3 and verbs.include?(arguments[1]))
            client.say(channel: data.channel, text: "I don't understand")
            return nil
        end

        winner = ::User.find_by_slack_mention!(client.team, arguments[0])
        loser = ::User.find_by_slack_mention!(client.team, arguments[2])
        ::Challenge.create!(
          team: client.team,
          channel: data.channel,
          created_by: winner,
          challengers: [winner],
          challenged: [loser],
          state: ::ChallengeState::PROPOSED
        )
        challenge.accept!(loser)
        challenge.lose!(loser)

        client.say(channel: data.channel, text: "Got it. #{winner} #{verbs.sample} #{loser}", gif: 'noted')
        logger.info "record: #{data.user} - #{arguments}"
      end
    end
  end
end
