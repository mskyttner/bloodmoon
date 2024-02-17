local fm = require "fullmoon"
local lsqlite3 = require "lsqlite3"
local dbm = lsqlite3.open('synth.db')

local function entity(t, limit)

  limit = limit or "-1"

  local query = string.format("select * from %s limit %s", t, limit)

  local results = {}
  for r in dbm:nrows(query) do
    table.insert(results, r)
  end

  return results

end

local function product(id)

  -- since we should pretend that these come from different sources...
  -- otherwise a join would be better and faster

  local q_product = string.format("select * from products where productId ='%s'", id)
  local q_prices = string.format("select * from prices where productId = '%s'", id)
  local q_reviews = string.format("select * from reviews where productId = '%s'", id)

  local products = {}
  for r in dbm:nrows(q_product) do table.insert(products, r) end

  local prices = {}
  for r in dbm:nrows(q_prices) do table.insert(prices, r) end

  local reviews = {}
  for r in dbm:nrows(q_reviews) do table.insert(reviews, r) end

  local response = {}

  response["products"] = products
  response["prices"] = prices
  response["reviews"] = reviews

  return response

end

fm.setRoute("/", function() return [[
<!DOCTYPE html><html><head></head>
<body>

<h1>Frontend / "Webshop":</h1>
<p>Very "bare bones". Conceptually:
<p>The products route combines info from the three different API endpoints to simulate a frontend which gets data from different independent API endpoints. Otherwise obviously a join would have been used to combine data for the different entities.</p>

<li><a href='/products'>Paged list of products</a></li>
<li><a href='/products/6ef442c2-4270-46bc-ad91-cde8d86ce6eb'>Details for a specific product using any id from the above product listing</a></li>

<h1>Backend / API:</h1>
<p>Full list of entities, would not be exposed to end-users, not under auth here for demo purpose.
<table>
  <td><a href='/api/reviews'>Reviews</a></td>
  <td><a href='/api/prices'>Prices</a></td>
  <td><a href='/api/products'>Products</a></td>
</table>

<h1>Help / Manual:</h1>

<a href='/help.txt'>Bloodmoon server man page (redbean APE w/ fullmoon and dynamic sqlite db embedded)</a>

<h1>Admin:</h1>
<p>Test of auth-only feature</p>
<table>
  <td><a href='/auth-only'>Admin functionality!</a></td>
</table>


</body></html>]]
end)

-- Docs etc
fm.setRoute("/help.*", fm.serveAsset)
fm.setRoute("/favicon.ico", fm.serveAsset)

-- Admin

local hash = "SHA384"
local pass = GetCryptoHash(hash, "redpill")
local basicAuth = fm.makeBasicAuth({user = pass}, {realm = "Need password", hash = hash})

fm.setRoute({"/auth-only", authorization = basicAuth},
  fm.serveContent(200, "Welcome!"))

-- "Backend"

fm.setRoute(fm.GET "/api/reviews", function(r)
  return fm.serveContent("json", entity("reviews"))
end)

fm.setRoute(fm.GET "/api/prices", function(r)
  return fm.serveContent("json", entity("prices"))
end)

fm.setRoute(fm.GET "/api/products", function(r)
  return fm.serveContent("json", entity("products"))
end)

-- "Frontend"

fm.setRoute(fm.GET "/products", function(r)
  local products = entity("products", "20")
  return fm.serveContent("json", products)
end)

fm.setRoute(fm.GET "/products(/:id)", function(r)
    return fm.serveContent("json", product(r.params.id))
end)

-- configure the main loop with the provided parameters
fm.run()
