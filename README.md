# json_data_test

Application loads some JSON data via several requests, stores in core data and add filtering

# Workflow

At the start of the app, 3 post requests are performed to retrieve info about Appointment, Appointment Type and User enteties, which will be used to display Appointments in UITableView. Request are loaded asynchronous, using dispatch_group, which waits until all responses return. User can view list of appointemnts in tableviewcell, which will contain info about appointment, start and end date, appointment user and appointment users avatar. There is UISwitch that lets show only approved appointments (which have bold title), and there is search field which enables to search using users name as a search term 

# User scenario

- open app
- toggle switch to show only confirmed appointments
- toggle switch back to show all appointments
- press on search field
- enter search term (example : ivan)
- press on return key, search will show appointments with "ivan" user
- toggle switch to reset
