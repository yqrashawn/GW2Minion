-- Thanks to nupogodi, saved me hours of work :)
function GetCurrentTime()
	return os.time()
end

if not mc_core then
  mc_core={}
end

function mc_core.inheritsFrom( baseClass )
    local new_class = {}
    local class_mt = { __index = new_class }

    function new_class:create()
        local newinst = {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    if baseClass then
        setmetatable( new_class, { __index = baseClass } )
    end
    return new_class
end

local cocreate = coroutine.create
local coyield = coroutine.yield
local coresume = coroutine.resume
local codead = function(co) return co == nil or coroutine.status(co) == "dead" end

--- BASE NODE
mc_core.Node = {}
function mc_core.Node:Tick(pTreeWalker)
   if codead(self.runner) then
      self.runner = cocreate(self.Execute)
   end

   local status, rv = coresume(self.runner, self, pTreeWalker);

   if codead(self.runner) then
      self.last_status = rv
   else
      self.last_status = "Running"
   end
	--d(tostring(self.last_status))
   return self.last_status
end

function mc_core.Node:Start()
   self.runner = nil
   self.last_status = nil
end

mc_core.Action = mc_core.inheritsFrom(mc_core.Node)
function mc_core.Action:new(func,...)
   local _func = func
   if type(_func)=="string" then
    _func=loadstring(_func)
   end
   local o = { action = _func, runner = nil, type = "Action", parent = nil,args=arg}
   setmetatable(o, self)
    self.__index = self
    return o
end

function mc_core.Action:Execute(pTreeWalker)
   if self.args then
     return self.action(pTreeWalker.object,pTreeWalker, unpack(self.args))
   else
     return self.action(pTreeWalker.object,pTreeWalker)
   end
end

mc_core.Condition = mc_core.inheritsFrom(mc_core.Node)
function mc_core.Condition:new(func,...)
   local _func = func
   if type(_func)=="string" then
    _func=loadstring(_func)
   end
   local o = { action = _func, runner = nil, type = "Action", parent = nil,args=arg}
   setmetatable(o, self)
    self.__index = self
    return o
end

function mc_core.Condition:Execute(pTreeWalker)
   if self.args then
     return self.action(pTreeWalker.object,pTreeWalker, unpack(self.args))
   else
     return self.action(pTreeWalker.object,pTreeWalker)
   end
end

--- BASE CONTAINER
mc_core.Container = mc_core.inheritsFrom(mc_core.Node)
function mc_core.Container:new(...)
    local o = { children = {}, runner = nil, type = "Container", parent = nil }
    setmetatable(o, self)
    self.__index = self

    for i,v in ipairs(arg) do
        o:Add(v)
    end

    return o
end

function mc_core.Container:Add(comp)
   if (type(comp) == "function") then
      comp = mc_core.Action:new(comp)
   end
  
    table.insert(self.children, comp)
    comp.parent = self
    return self
end

mc_core.Sequence = mc_core.inheritsFrom(mc_core.Container)
function mc_core.Sequence:Execute(pTreeWalker)
   for i,comp in ipairs(self.children) do
      comp:Start()
      while comp:Tick(pTreeWalker) == "Running" do
         coyield("Running")
      end

      if (comp.last_status == false) then
         return false
      end
   end

   return true
end

mc_core.PrioritySelector = mc_core.inheritsFrom(mc_core.Container)
function mc_core.PrioritySelector:Execute(pTreeWalker)
   for i,comp in ipairs(self.children) do
      comp:Start()
      while comp:Tick(pTreeWalker) == "Running" do
         coyield("Running")
      end

      if (comp.last_status == true) then
         return true
      end
   end

   return false
end

mc_core.RandomSelector = mc_core.inheritsFrom(mc_core.Container)
function mc_core.RandomSelector:Execute(pTreeWalker)
   self.children = mc_core.shuffle(self.children)
   for i,comp in ipairs(self.children) do
      comp:Start()
      while comp:Tick(pTreeWalker) == "Running" do
         coyield("Running")
      end

      if (comp.last_status == true) then
         return true
      end
   end

   return false
end

mc_core.AbstractDecorator = mc_core.inheritsFrom(mc_core.Node)
function mc_core.AbstractDecorator:new(predicate, child)
   if (type(child) == "function") then
      child = mc_core.Action:new(child)
   end
    local _predicate = predicate
    if type(_predicate)=="string" then
       _predicate=loadstring(_predicate)
    end
    local o = { predicate = _predicate, child = child }
    setmetatable(o, self)
    self.__index = self
    return o
end

-- Decorator inherits from AstractDecorator
mc_core.Decorator = mc_core.inheritsFrom(mc_core.AbstractDecorator)
function mc_core.Decorator:Execute(pTreeWalker)
    local pred_rv = self.predicate()
    self.child:Start()
    if pred_rv then
        while self.child:Tick(pTreeWalker) == "Running" do
           coyield("Running")
        end

        return self.child.last_status
    else
        return false
    end
end

-- DecoratorContinue inherits from AstractDecorator
mc_core.DecoratorContinue = mc_core.inheritsFrom(mc_core.AbstractDecorator)
function mc_core.DecoratorContinue:Execute(pTreeWalker)
    local pred_rv = self.predicate()
    if pred_rv then
       self.child:Start()
        while self.child:Tick(pTreeWalker) == "Running" do
           coyield("Running")
        end
        return self.child.last_status
    else
        return true
    end
end

-- Filter inherits from AstractDecorator
mc_core.Filter = mc_core.inheritsFrom(mc_core.AbstractDecorator)
function mc_core.Filter:Execute(pTreeWalker)
    local pred_rv = self.predicate()
    self.child:Start()
    if pred_rv then
        while self.child:Tick(pTreeWalker) == "Running" do
           coyield("Running")
        end

        return self.child.last_status
    else
        return false
    end
end

-- Wait inherits from AbstractDecorator
mc_core.Wait = mc_core.inheritsFrom(mc_core.AbstractDecorator)
function mc_core.Wait:new(predicate, child, timeout)
    --d(tostring(predicate).. " || " ..tostring(child).." || " ..tostring(timeout))
	local o = mc_core.AbstractDecorator.new(self, predicate, child)
    o.timeout = timeout
    return o
end

function mc_core.Wait:Execute(pTreeWalker)
	local time_start = GetCurrentTime()
	 while (GetCurrentTime() - time_start < self.timeout) do
		--d("EXEC Wait: "..tostring( time_start ) .. " || "..tostring(GetCurrentTime() ) .." || " ..tostring(self.timeout))
   
        local pred_rv = self.predicate()
        if pred_rv then
           self.child:Start()
            while self.child:Tick(pTreeWalker) == "Running" do
              coyield("Running")
           end
           return self.child.last_status
        end
        coyield("Running")
    end
    return false
end

-- WaitContinue inherits from AbstractDecorator
mc_core.WaitContinue = mc_core.inheritsFrom(mc_core.AbstractDecorator)
function mc_core.WaitContinue:new(predicate, child, timeout)
	local o = mc_core.AbstractDecorator.new(self, predicate, child)
    o.timeout = timeout
    return o
end

function mc_core.WaitContinue:Execute(pTreeWalker)
    local time_start = GetCurrentTime()
	--d("EXEC WaitContinue: "..tostring( time_start ) .. " || "..tostring(GetCurrentTime() ) .." || " ..tostring(self.timeout))
	
    while (GetCurrentTime() - time_start < self.timeout) do
       local pred_rv = self.predicate()
        if pred_rv then
           self.child:Start()
            while self.child:Tick(pTreeWalker) == "Running" do
              coyield("Running")
           end
           return self.child.last_status
        end
        coyield("Running")
    end
    return true
end

-- RepeatUntil inherits from AbstractDecorator
mc_core.RepeatUntil = mc_core.inheritsFrom(mc_core.AbstractDecorator)
function mc_core.RepeatUntil:new(predicate, child, timeout)
    local o = mc_core.AbstractDecorator.new(self, predicate, child)
    o.timeout = timeout
    return o
end
-- repeat child() until predicate() true or targettime passed, 
function mc_core.RepeatUntil:Execute(pTreeWalker)
    local time_start = GetCurrentTime()
    --d("EXEC Wait: "..tostring( time_start ) .. " || "..tostring(GetCurrentTime() ) .." || " ..tostring(self.timeout))
		
    while (GetCurrentTime() - time_start < self.timeout) do
        local pred_rv = self.predicate()
        if not pred_rv then
           self.child:Start()
            while self.child:Tick(pTreeWalker) == "Running" do
              coyield("Running")
           end
           if self.child.last_status == false then return false end
            coyield("Running")
        else
            return true
        end
    end
    return false
end

mc_core.TreeWalker = {}
function mc_core.TreeWalker:new(pname,pobject,logictree)
   local o = {name=pname, object=pobject, logic = logictree }
   setmetatable(o, self)
    self.__index = self
    return o
end
function mc_core.TreeWalker:Tick()

   self.logic:Tick(self)

   if (self.logic.last_status ~= "Running") then
      self.logic:Start()
   end
end

function mc_core.Sleep(timeout)
    return mc_core.WaitContinue:new(function() return false end, nil, timeout)
end

function mc_core.shuffle(t)
  local n = #t

  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end

  return t
end