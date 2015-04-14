## THIS IS INCOMPLETE

(replace 'taskname' with the task itself)

# new task routing
create the proper routes in `/config/routes.rb`:

    # task main routes
    get "taskname", to: "fixer#taskname", :as => "taskname"
    get "taskname/progress", to: "fixer#progress_taskname", :as => "taskname_progress"
    get "taskname/progress_all", to: "fixer#progress_taskname_all", :as => "taskname_progress_all"

    # task progress json endpoints
    get "taskname/progress_user", to: "fixer#session_progress_taskname_for_sheet"
    get "taskname/progress_sheet", to: "fixer#progress_sheet_taskname"

# back-end ui (ruby/rails)
- add the necessary code to `/app/controllers/fixer_controller.rb` to handle the new routes. For example: `def taskname`, `def progress_taskname`, `def progress_taskname_all`, `def session_progress_taskname_for_sheet`, `def progress_sheet_taskname`
- add the necessary code to `/app/models/sheet.rb` to support the new task. pay special attention to `self.polygons_for_task` and `self.random_unprocessed`


add proper files to `/app/views/fixer/`:

mention `class="compact"` for button wrapper
- `taskname.html.erb`
- `progress_taskname.html.erb`
- `progress_taskname_all.html.erb`

# front end ui

## javascript
add proper files to `/app/assets/javascripts/`:

- `inspector_taskname.coffee`
- `progress_taskname.coffee`

create a tutorial video

## css
add proper files to `/app/assets/stylesheets/` (if necessary):
- `taskname.css.scss`

if task has its own images
- add images folder: `/app/assets/images/taskname/`

## score
`/app/views/partials/_score.html.erb` shows the progress submenus (view my progress, consensus progress)
modify it to support the new progress views that apply

# global site vars
for `/app/controllers/application_controller.rb`:

- global_variables(): add the task to the list
- sort_tasks(): update sorting

# consensus
add consensus rake tasks in `/lib/tasks/flag_processing.rake`