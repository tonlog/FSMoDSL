

class AbstractEvent
    attr_reader :event_name, :event_code
    def initialize event_name, event_code
        @event_name, @event_code = event_name, event_code
    end
end

class Command   < AbstractEvent;end
class Event     < AbstractEvent;end

class Transition
    attr_reader :source_state, :evnet, :target_state

    def initialize arg
        @source_state = arg[:source]
        @event = arg[:event]
        @target_state = arg[:target_state]
    end
end



class Commands < Array

    alias :add_more :<<

    def << new_command
        raise Exception, 'It is not a vaild Command.' unless new_command.is_a?(Command)
        self.add_more new_command
    end

    def push new_command
        raise Exception, 'It is not a vaild Command.' unless new_command.is_a?(Command)
        self.add_more new_command
    end
end
class Transitions < Hash
    def []=(key, value)
        raise Exception, 'Invalid with key and value pair given.' unless key.is_a?(String) && value.is_a?(Transition)
        super
    end
end
class States < Array;end



class State
    attr_reader :state_name
    attr_accessor :transitions, :actions

    def initialize args
        @state_name = args[:state_name] || 'Default'
        @transitions = args[:transitions] || Transitions.new
        @actions = args[:actions] || Commands.new
    end

    def add_transition event, target_state
        assert(target_state.nil?, false)
        @transitions[event.event_code] = Transition.new(:source_state => self,:event => event, :target_state => target_state)
    end

    def get_all_targets
        @transitions.values.inject(States.new) { |target_states, each_target_state| target_states << each_target_state }
    end

    def has_transition? transition; @transitions.values.any? {|each_transition| each_transition === transition} end





end


class StateMachine
    attr_reader :start_state

    def initialize args
        @start_state = args[:start_state]
    end

    def get_all_states
        collect_states States.new, @start_state
    end

    def collect_states container, state
        raise Exception, "Given container is not a valid States Collection." if container.nil? || !container.is_a?(States)

        if container.any? {|inside_state| inside_state === state};
        else
            container << state
            state.get_all_targets.each { |each_target|
                self.collect_states container, each_target
            }
        end

    end

    private :collect_states

end
