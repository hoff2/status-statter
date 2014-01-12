module StatusStatter
  module Config
    CONSUMER_KEY    = '???'
    CONSUMER_SECRET = '???'
    OAUTH_TOKEN     = '???'
    OAUTH_SECRET    = '???'

    # which streaming API method to use -- other examples:
    # [ :firehose ]
    # [ :track, 'bacon', 'mom' ]
    API_MESSAGE     = [ :sample ]
  end
end
