# File response_format.rb
# encoding: UTF-8

module Sinatra
  module BombHelpers
    WireResponse = Struct.new(:status, :message)

    def create_wires(number_of_wires)
      wires = []
      speed_down_wire, speed_up_wire, diffusing_wire, detonating_wire = (0..number_of_wires.to_i).to_a.sample(4)
      number_of_wires.times do |wire_num|
        detonates = equal_wires?(wire_num, detonating_wire)
        speed_up = equal_wires?(wire_num, speed_up_wire)
        speed_down = equal_wires?(wire_num, speed_down_wire)
        diffuses = equal_wires?(wire_num, diffusing_wire)
        wires << Wire.new(color: '%06x' % (rand * 0xffffff),
                 detonates: detonates, speeds_up: speed_up,
                 speeds_down: speed_down, diffuses: diffuses)
      end
      wires
    end

    def cut_wire_response(bomb, status, message, accept)
      bomb.status = status
      bomb.save
      format_response(message, accept)
    end

    def cut_wire_status(wire)
      WireResponse.new(status: :exploded, message: 'Boom')  if wire.detonates
      WireResponse.new(status: :diffused, message:'SUCCESS') if wire.diffuses
      WireResponse.new(status: :active, message: 'SPEED_UP') if wire.speeds_up
      WireResponse.new(status: :active, message:'SPEED_DOWN') if wire.speeds_down
    end

    private

    def equal_wires?(num, wire)
      num.equal?(wire)
    end
  end
  helpers BombHelpers
end
