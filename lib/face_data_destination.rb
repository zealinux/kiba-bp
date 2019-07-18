# frozen_string_literal: true

# lib/face_data_destination.rb

require 'pg'

class FaceDataDestination

  def initialize(connect_url)
    @conn = PG.connect(connect_url)
    @conn.prepare('insert_face_feature', 'insert into faces (id, feature) values ($1, $2)')
  end

  def write(row)
    @conn.exec_prepared('insert_face_feature', [row[:id], row[:feature]])
  rescue PG::Error => ex
    puts ex.message
    # Maybe, write to db table or file
  end

  def close
    @conn.close
    @conn = nil
  end
end
