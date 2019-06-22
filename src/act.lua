-- ACTIONS FRAMEWORK

-- This framework allows actions to be enqueued and executed
-- in TIC() so that you can have a procedure that runs
-- over and over again on every frame until it ends, followed
-- by another one that's queued up, etc, etc.

-- When you enqueue an action with A_Enq(), it will be run every
-- frame until it returns TRUE, at which point it's discarded
-- and the next action will start, until it too returns TRUE
-- and is discarded, and so on and so forth.

-- There are also MODAL actions, which are actions that are started
-- from other actions, in which case BOTH the parent and the child
-- action will run every frame, but the isFg parameter will indicate
-- if each is the foreground action (the child) or the background
-- action (the parent). This is useful if an action needs to block
-- and display a sub-action (like a menu) before proceeding with
-- its main task.

-- Actions state.
A={
 -- Enqueued actions. Each action has:
 --  clk: counts up 1 each frame the action is alive.
 --  proc: the function to call to process the action. If this
 --   function returns TRUE, the action is complete and will be
 --   removed; else the action will remain and proc will be called
 --   again on the next frame.
 --  (other fields are custom state to the action).
 --  afl: action flags (see below).
 queue={},
}

-- Action flags:

-- If set, this action is a modal sub-action of the
--   action that follows it. In this case the modal action runs,
--   and the parent action also gets called, but is given a
--   parameter to indicate that it's blocked.
#define AF_MODAL 1

-- Resets the actions.
function A_Reset()
 A.queue={}
end

-- Enqueues an action at the back (end) of the queue.
function A_Enq(proc,state,afl)
 ActEnq(proc,state,afl)
end

-- Returns TRUE if there are actions in the queue.
--function A_HasActions() return #A.queue>0 end

-- Runs the action that's at the head of the queue. Returns TRUE if
-- an action was run; FALSE if there were no actions to run in the
-- queue.
function A_Run()
 if #A.queue<1 then return FALSE end

 -- What's the last modal action in the queue?
 local lma=nil
 for i=#A.queue,1,-1 do
  if A.queue[i].afl&AF_MODAL>0 then lma=i break end
 end
 if lma then
  -- There are modal actions in the queue.
  -- Actions 2..lma+1 are background actions that need to run 
  -- in reverse order with isFg==FALSE (usually just for rendering).
  -- In particular, lma+1 is a non-modal action that started
  -- the chain of modal action, if it exists.
  local s=min(lma+1,#A.queue)
  for i=s,2,-1 do
   -- FALSE for isFg means "you are not the foreground action
   -- because you are blocked by a modal action".
   (A.queue[i].proc)(A.queue[i],FALSE)
  end
 end

 -- Now run the action that's at the front of the queue.
 local a=A.queue[1]
 -- Arguments are: action and isForeground
 if (a.proc)(a,TRUE) then
  -- Action is done, so remove it.
  remove(A.queue,ListFind(A.queue,a))
 else
  -- Action not yet done, so keep it for next frame.
  a.clk=a.clk+1
 end
 return TRUE
end

--END OF API-----------------------------------------------------
-----------------------------------------------------------------

-- Enqueues the action.
function ActEnq(proc,state,afl)
 ast(proc)
 state=state or {}
 state.proc=proc
 state.clk=0
 state.afl=afl or 0
 if state.afl&AF_MODAL>0 then
  -- Modal actions go at the front of the queue.
  insert(A.queue,1,state)
 else
  -- Otherwise, insert at the back of the queue.
  insert(A.queue,state)
 end
end


