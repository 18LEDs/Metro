#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'json'
require 'pry'

input_route = ARGV[0]
input_stop = ARGV[1]
input_direction = ARGV[2]

# input_route = "5 - Brklyn Center - Fremont - 26th Av - Chicago - MOA"
# input_stop = "7th St  and Olson Memorial Hwy"
# input_direction = "south"


direction_hash = [{"Direction" => "south", "Id" => "1"},
                  {"Direction" => "east", "Id" => "2"},
                  {"Direction" => "west", "Id" => "3"},
                  {"Direction" => "north", "Id" => "4"}]


def scrapeDirectionId(input_direction, direction_hash)
    input_direction = input_direction.downcase
    if d = direction_hash.find { |d| d["Direction"] == input_direction }
        @direction_id = d["Id"]
        if @directions_list.find { |d| d["Value"] == @direction_id }
        else
            puts 'Direction is not valid for this route.'
            exit
        end
    else
        puts 'Direction not found'
        exit
    end
end

def getRoutes
    routes_endpoint = 'http://svc.metrotransit.org/NexTrip/Routes?format=json'
    route_URI = URI(routes_endpoint)
    req = Net::HTTP.get(route_URI)
    @route_list = JSON.parse(req)
end

def scrapeRouteId(input_route)
    if r = @route_list.find { |r| r["Description"] == input_route }
        @route_id = r["Route"]
    else
        puts 'Route ID not found for entered route.'
        exit
    end
end

def getStops(route_id, direction_id)
    stops_endpoint = "http://svc.metrotransit.org/NexTrip/Stops/#{route_id}/#{direction_id}?format=json"
    stops_URI = URI(stops_endpoint)
    req = Net::HTTP.get(stops_URI)
    @stops_list = JSON.parse(req)
end

def scrapeStopId(input_stop)
    if s = @stops_list.find { |s| s["Text"] == input_stop }
        @stop_id = s["Value"]
    else
        puts 'Stop not found'
        exit
    end   
end

def getDirections(route_id)
    directions_endpoint = "http://svc.metrotransit.org/NexTrip/Directions/#{route_id}?format=json"
    stops_URI = URI(directions_endpoint)
    req = Net::HTTP.get(stops_URI)
    @directions_list = JSON.parse(req)
end

def getNextTimeDeparture(route_id, direction_id, stop_id)
    time_endpoint = "http://svc.metrotransit.org/NexTrip/#{route_id}/#{direction_id}/#{stop_id}?format=json"
    time_URI = URI(time_endpoint)
    req = Net::HTTP.get(time_URI)
    @departure_list = JSON.parse(req)
    puts @departure_list[0]["DepartureText"] + "utes until next departure!"
end


##################
## nextBus flow ##
##################

def user_assistance(direction_hash)
    puts 'Welcome to GRE NVR-B-L8!'
    print 'Please enter Bus Route: '
    input_route = gets.chomp.gsub(/"/, "")
    require 'pry'; binding.pry
    print 'Please enter Bus Stop: '
    input_stop = gets.chomp.gsub(/"/, "")
    print 'Please enter your direction: '
    input_direction = gets.chomp.gsub(/"/, "")
    nextBus(input_route, input_stop, input_direction, direction_hash)
end

def nextBus(input_route, input_stop, input_direction, direction_hash)
    if @route_list.nil?
        getRoutes
    end
    scrapeRouteId(input_route)
    getDirections(@route_id)
    scrapeDirectionId(input_direction, direction_hash)
    getStops(@route_id, @direction_id)
    scrapeStopId(input_stop)
    getNextTimeDeparture(@route_id, @direction_id, @stop_id)
end


#############################################
##  Startup check for cmd passed arguments ##
#############################################

if ARGV[0].nil? || ARGV[1].nil? || ARGV[2].nil?
    user_assistance(direction_hash)
else
    nextBus(input_route, input_stop, input_direction, direction_hash)
end
