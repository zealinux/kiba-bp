# frozen_string_literal: true

# lib/face_data_source.rb

require 'mysql2'
require 'uri'

class FaceDataSource
  # connect_url should look like;
  # mysql://user:password@localhost/dbname
  def initialize(config)
    # @mysql = Mysql2::Client.new(connect_hash(connect_url))
    @mysql = Mysql2::Client.new(config)
  end

  def each
    results = @mysql.query('select * from kiwi_face_person_face_data limit 1000000;', as: :hash, symbolize_keys: true)
    results.each do |row|
      yield(row)
    end
  end

  private

  def connect_hash(url)
    u = URI.parse(url)
    {
      host: u.host,
      username: u.user,
      password: u.password,
      port: u.port,
      database: u.path[1..-1]
    }
  end
end
