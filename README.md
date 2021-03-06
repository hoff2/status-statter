* StatusStatter

Watch tweets coming from the Twitter Streaming API. Record things
about them.

The StatusStatter class watches the API for as long as you like
(between when you call the `run` method and when you call `stop`
anyway). You can `register` objects on it that keep track of stuff
happening in twitterland. Those objects just need to know how to
`record` a tweet and some way to `report` their results when finished.
A few tracker classes are included.

This uses the tweetstream gem. You'll need to configure your oauth
bits. Copy `lib/status_statter/config_sample.rb` to
`lib/status_statter/config.rb` and put them in there.

I recommend running this in Ruby 1.9 due to my embrace of Ruby 1.9
idioms not compatible with 1.8 and Tweetstream's alleged
incompatibility with Ruby 2.0, although I ran it everal times in Ruby
2.0 while developing it without problems.

There's an executable at `bin/status_statter.rb` that will run until
you hit control-c. You can modify it to your needs or just treat it as
a usage example.
