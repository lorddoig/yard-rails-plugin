module YARD
  module Rails
    module Plugin
      class Routes
        def initialize
          puts '[rails-plugin] Analyzing Routes...'
          ::Rails.application.reload_routes!
          all_routes = ::Rails.application.routes.routes
          @routes = all_routes.collect do |route|
            reqs = route.requirements.dup
            rack_app =  route.app.class.name.to_s =~ /^ActionDispatch::Routing/ ? nil : route.app.inspect
            constraints = reqs.except(:controller, :action).empty? ? '' : reqs.except(:controller, :action).inspect
            if reqs[:controller]
              controller = reqs[:controller] + '_controller'
              controller = (controller.split('_').map{ |s| s[0].upcase + s[1..-1] }).join('')
              controller = (controller.split('/').map{ |s| s[0].upcase + s[1..-1] }).join('::')
            else
              controller = ''
            end
            { name: route.name.to_s, verb: stringify_verb_regex(route.verb), path: route.path.spec.to_s,
              controller: controller , action: reqs[:action], rack_app: rack_app, constraints: constraints}
          end
          @routes.reject! { |r| r[:path] =~ %r{/rails/info/properties|^/assets} }
        end

        def stringify_verb_regex(verb)
          verb.source.gsub(/(\^|\$)/, '')
        end

        def generate_routes_description_file(filename)
          File.open(File.join(Dir.pwd, filename), 'w') do |f|
            f.puts "<h1>Routes</h1><br /><br />"
            f.puts "<table><tr style='background: #EAF0FF; font-weight: bold; line-height: 28px; text-align: left'><th>&nbsp;</th><th>&nbsp;&nbsp;Verb</th><th>&nbsp;&nbsp;Endpoint</th><th>&nbsp;&nbsp;Destination</th></tr>"
            i = 0
            @routes.each do |r|
              odd_or_even = ((i % 2  == 0) ? 'even' : 'odd')
              if r[:rack_app]
                destination = "<pre>#{r[:rack_app].inspect} #{r[:constraints]}</pre>"
              else
                action = normalized_action(r)
                destination = "{#{r[:controller]} #{r[:controller]}}##{action} #{r[:constraints]}"
              end
              endpoint = r[:path].gsub(/(:|\*)\w+/) { |m| "<span style='font-family: monospace; color: green'>#{m}</span>"}
              f.puts "<tr class='#{odd_or_even}'><td>#{r[:name]}</td><td>#{r[:verb]}</td><td>#{endpoint}</td><td>#{destination}</td></tr>"
              i += 1
            end
            f.puts "</table>"
          end
        end

        def enrich_controllers
          @routes.each do |r|
            if r[:controller] && node = YARD::Registry.resolve(nil, r[:controller], true)
              (node[:routes] ||= []) << r
            end

            action = normalized_action(r)
            if r[:controller] && action && node = YARD::Registry.resolve(nil, r[:controller] + '#' + action, true)
              (node[:routes] ||= []) << r
            end
          end
        end

        private
        # The action can be a RegExp
        def normalized_action(route)
          action = route[:action]
          action.respond_to?(:source) ? action.source : action
        end
      end
    end
  end
end
