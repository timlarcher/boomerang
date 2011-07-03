require_relative '../lib/boomerang/db_connection'
require_relative '../lib/boomerang/client'
require_relative '../lib/boomerang/matcher'

Boomerang::Client.find(:all).each do |client|
  Boomerang::Matcher::do_match( client.id )
end
