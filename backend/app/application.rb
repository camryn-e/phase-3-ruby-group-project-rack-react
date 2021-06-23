class Application

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)
    
    if req.path.match(/pride-events/)
      if req.env["REQUEST_METHOD"] == "POST"
        event_city_id = req.path.split('/cities/').last.split('/pride-events/').last
        input = JSON.parse(req.body.read)
        pride_event = PrideEvent.create(title: input["title"], category: input["category"], description: input["description"], age_rating: input["age rating"], city_id: event_city_id)
        return [200, { 'Content-Type' => 'application/json' }, [pride_event.to_json]]
      elsif req.env["REQUEST_METHOD"] == "DELETE"
        event_city_id = req.path.split('/cities/').last.split('/pride-events/').first
        city = City.find_by(id: event_city_id)
        event_id = req.path.split('/pride-events/').last
        pride_event = city.pride_events.find_by(id: event_id)
        city.pride_events.delete(event_id)
      else
        event_city_id = req.path.split('/cities/').last.split('/pride-events/').last
        clicked_event = PrideEvent.find(event_city_id)
        return [200, { 'Content-Type' => 'application/json' }, [clicked_event.to_json]]
      end
    elsif req.path.match(/cities/)
      if req.env["REQUEST_METHOD"] == "POST"
        input = JSON.parse(req.body.read)
        new_city = City.create(name: input["name"])
        return [200, { 'Content-Type' => 'application/json' }, [new_city.to_json]]
      elsif req.path.split('/cities').length == 0
        all_cities = City.all
        return [200, { 'Content-Type' => 'application/json' }, [ all_cities.to_json ]]
      else
        city_id = req.path.split('/cities/').last
        return [200, { 'Content-Type' => 'application/json' }, [City.find_by(id: city_id).to_json({:include => :pride_events}) ]]
      end
    else
      resp.write "Path Not Found"
    end
    
    resp.finish

  end

end
