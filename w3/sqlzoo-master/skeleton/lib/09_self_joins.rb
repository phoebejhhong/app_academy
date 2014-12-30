# == Schema Information
#
# Table name: stops
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: route
#
#  num         :integer      not null, primary key NOT TRUE LIARS
#  company     :string       not null, primary key
#  pos         :integer      not null, primary key
#  stop        :integer

require_relative './sqlzoo.rb'

def num_stops
  # How many stops are in the database?
  execute(<<-SQL)
    SELECT
      COUNT(id)
    FROM
      stops
  SQL
end

def craiglockhart_id
  # Find the id value for the stop 'Craiglockhart'.
  execute(<<-SQL)
    SELECT
      id
    FROM
      stops
    WHERE
      name = 'Craiglockhart'
  SQL
end

def lrt_stops
  # Give the id and the name for the stops on the '4' 'LRT' service.
  execute(<<-SQL)
    SELECT
      stops.id, stops.name
    FROM
      stops
    JOIN
      route ON stops.id = route.stop
    WHERE
      route.company = 'LRT' AND route.num = '4'
  SQL
end

def connecting_routes
  # The query shown gives the number of routes that visit either London Road
  # (149) or Craiglockhart (53). Run the query and notice the two services
  # that link these stops have a count of 2. Add a HAVING clause to restrict
  # the output to these two routes. WHY DID THIS WORK?
  execute(<<-SQL)

  SELECT
    route.company, route.num, COUNT(route.num)
  FROM
    route
  JOIN
    stops ON stops.id = route.stop
  WHERE
    route.stop = 53 OR route.stop = 149
  GROUP BY
    route.company, route.num

  SQL
end

def cl_to_lr
  # Execute the self join shown and observe that b.stop gives all the places
  # you can get to from Craiglockhart, without changing routes. Change the
  # query so that it shows the services from Craiglockhart to London Road.
  execute(<<-SQL)
  SELECT
    a.company, a.num, a.stop, b.stop
  FROM
    route AS a
  JOIN
    route AS b ON a.company = b.company AND a.num = b.num
  WHERE
    a.stop = 53 -- and b.num in (
    --   SELECT
    --     c.num
    --   FROM
    --     route c
    --   WHERE
    --     c.stop = 149
    -- ) THIS IS RIGHT SPEC IS DUMB
  SQL
end

def cl_to_lr_by_name
  # The query shown is similar to the previous one, however by joining two
  # copies of the stops table we can refer to stops by name rather than by
  # number. Change the query so that the services between 'Craiglockhart' and
  # 'London Road' are shown. If you are tired of these places try
  # 'Fairmilehead' against 'Tollcross'
  execute(<<-SQL)
    SELECT
      a.company, a.num, astop.name, bstop.name
    FROM
      route AS a
    JOIN
      route AS b ON a.company = b.company AND a.num = b.num
    JOIN
      stops AS astop ON a.stop = astop.id
    JOIN
      stops AS bstop ON b.stop = bstop.id
    WHERE
      astop.name = 'Craiglockhart'

  SQL
end

def haymarket_and_leith
  # Give a list of all the services which connect stops 115 and 137
  # ('Haymarket' and 'Leith')

  execute(<<-SQL)
    SELECT
      a.company, a.num
    FROM
      route AS a
    JOIN
      route AS b ON a.company = b.company AND a.num = b.num
    WHERE
      a.stop = 115 AND b.stop = 137
    GROUP BY
      a.company, a.num
  SQL
end

def craiglockhart_and_tollcross
  # Give a list of the services which connect the stops 'Craiglockhart' and
  # 'Tollcross'
  execute(<<-SQL)
    SELECT
      a.company, a.num
    FROM
      route AS a
    JOIN
      route AS b ON a.company = b.company AND a.num = b.num
    JOIN
      stops AS astop ON a.stop = astop.id
    JOIN
      stops AS bstop ON b.stop = bstop.id
    WHERE
    astop.name = 'Craiglockhart' AND bstop.name = 'Tollcross'
    GROUP BY
      a.company, a.num
  SQL
end

def start_at_craiglockhart
  # Give a distinct list of the stops which may be reached from 'Craiglockhart'
  # by taking one bus, including 'Craiglockhart' itself. Include the company
  # and bus no. of the relevant services.
  execute(<<-SQL)
  SELECT
    bstop.name, a.company, a.num
  FROM
    route AS a
  JOIN
    route AS b ON a.company = b.company AND a.num = b.num
  JOIN
    stops AS bstop ON b.stop = bstop.id
  WHERE
    a.stop = 53
  SQL
end

def craiglockhart_to_sighthill
  # Find the routes involving two buses that can go from Craiglockhart to
  # Sighthill. Show the bus no. and company for the first bus, the name of the
  # stop for the transfer, and the bus no. and company for the second bus.
  execute(<<-SQL)
  SELECT
    a.num, a.company , bstop.name, c.num, c.company
  FROM
    route AS a
  JOIN
    route AS b ON a.company = b.company AND a.num = b.num
  JOIN
    route AS c ON b.stop = c.stop
  JOIN
    route AS d ON c.company = d.company AND c.num = d.num
  JOIN
    stops AS astop ON a.stop = astop.id
  JOIN
    stops AS bstop ON b.stop = bstop.id
  JOIN
    stops AS dstop ON d.stop = dstop.id
  WHERE
    astop.name = 'Craiglockhart' AND dstop.name = 'Sighthill'
  GROUP BY
    a.num, a.company, bstop.name, c.num, c.company
  SQL
end
