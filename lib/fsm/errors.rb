module FSM
  class InvalidStateTransition < RuntimeError
  end
  class UnknownState < RuntimeError
  end
end