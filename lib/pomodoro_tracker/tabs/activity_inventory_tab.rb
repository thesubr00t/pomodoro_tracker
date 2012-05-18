module PomodoroTracker
  class ActivityInventoryTab < SideTab
    include DynamicSideTab
    
    ENTER = "\n"

    def init_data(inventory = nil)
      @activity_inventory ||= inventory
    end

    def content
      para "Activity Inventory"

      para "Description Pomodori Estimate Actions"
      @activities = stack do
        @activity_inventory.backlog.each{ |activity| new_activity(activity) }
      end

      add_activity_section
    end

    private
    def do_today_button(activity)
      button "Do Today" do |add_button|
        activity.do_today
        add_button.parent.remove
      end
    end

    def delete_button(activity)
      button "Delete" do |delete_button|
        @activity_inventory.remove activity
        delete_button.parent.remove
      end
    end

    def new_activity(activity)
      flow do
        para activity.description
        para activity.pomodori
        para activity.estimate
        do_today_button(activity)
        delete_button(activity)
      end
    end

    def add_activity_section
      stack do
        para "Add an activity"
        flow do
          para "Description: "
          @description = edit_line
          para "Estimation: "
          @estimate = edit_line
          button "Add" do add_activity end
        end
      end
      keypress_handler
    end

    def add_activity
      # '' is converted to 0 when calling to_i so empty works just fine
      activity = Activity.new(@description.text, @estimate.text.to_i)
      @activity_inventory.add activity
      @activities.append { new_activity(activity) }
      @description.text = ''
    end

    def keypress_handler
      keypress do |key|
        if key == ENTER
          add_activity unless @description.text.empty?
        end
      end
    end

  end
end

