#!/usr/bin/env python
from bioblend.galaxy import GalaxyInstance
import time
import os
import json
import urllib2

# - Parameters
GALAXY_URL = 'http://localhost:80'
library_name = 'Local data'
history_name = 'History'
output_history_name = 'Output history'
outputDir = '/output'

# - Incoming from WES API
workflow_params_url = 'https://raw.githubusercontent.com/bedroesb/WES2Galaxy/Dev/example_data/dataMapping.json'
workflow_url = 'https://raw.githubusercontent.com/bedroesb/WES2Galaxy/Dev/example_data/amplicon.ga'
workflow_version = '0.1'


# - Create Galaxy Instance Object
gi = GalaxyInstance(
    GALAXY_URL, email='admin@galaxy.org', password='admin')
print('Connected to galaxy')

# - Create history
gi.histories.create_history(name=history_name)
histories = gi.histories.get_histories(name=history_name)
history_id = histories[0]['id']
print('History created with ID: ' + history_id)

# - Create Library
gi.libraries.create_library(name=library_name)
libraries = gi.libraries.get_libraries(name=library_name)
library_id = libraries[0]['id']
print('Library created with ID : ' + library_id)

# - Create folder
gi.libraries.create_folder(library_id, 'URLdata', description=None)
folder = gi.libraries.show_library(library_id, contents=True)[0]
print('Folder created with ID : ' + folder['id'])

# - Reading out workflow params
datamapping_response = urllib2.urlopen(workflow_params_url)
datamapping_data = json.load(datamapping_response)  

# - Upload data in library based on URL
for inputfile in datamapping_data['inputs']:
    gi.libraries.upload_file_from_url(library_id, inputfile['filename'], folder_id=folder['id'])
    print(inputfile['filename'] + ' uploaded to the datalibrary')

# - Load data in history
files = gi.libraries.show_library(library_id, contents=True)
for f in files:
    if f['type'] == 'file':
        gi.histories.upload_dataset_from_library(history_id, f['id'])

# - Reading out input workflow
workflow_response = urllib2.urlopen(workflow_url)
workflow_data = json.load(workflow_response)  

# - Check for installed workflow
workflows = gi.workflows.get_workflows()
for workflow in workflows:
    if workflow['name'] == workflow_data['name'] and workflow_data['format-version'] == workflow_version:
        workflow_id = workflow['id']
        print('Workflow is available with ID: ' + workflow_id)
    else:
        print('This workflow is not available.')

# - Examine workflow
wf = gi.workflows.show_workflow(workflow_id)
print('Inputs workflow:' + str(wf['inputs']))

# - Determining input data
datamap = dict()
for inputname in datamapping_data['inputs']:
    dataset = gi.histories.show_matching_datasets(
        history_id, name_filter=inputname['filename'])
    print('Input data step {}: '.format(
        inputname['step']) + dataset[0]['name'])
    datamap[inputname['step']] = {'src': 'hda', 'id': dataset[0]['id']}

# - Running workflow
gi.workflows.invoke_workflow(
    workflow_id, inputs=datamap, history_name=output_history_name)
print('Workflow invoked')
time.sleep(2)
output_histories = gi.histories.get_histories(name=output_history_name)
output_history_id = output_histories[0]['id']
print('Output history ID: ' + output_history_id)

while gi.histories.get_status(output_history_id)['percent_complete'] != 100:
    time.sleep(1)
    if gi.histories.get_status(output_history_id)['state_details']['error'] != 0:
        print('One of the steps in the workflow is giving an ERROR')
        break

print('Workflow Done.')

# - Export output files
output_files = gi.histories.show_history(
    output_history_id, contents=True,  visible=True)
for of in output_files:
    if of['history_content_type'] == 'dataset':
        print('Exporting ' + of['name'])
        gi.datasets.download_dataset(
            of['id'], file_path=outputDir)

# - Delete datalibrary
gi.libraries.delete_library(library_id)

# - Reset history
gi.histories.delete_history(history_id)
gi.histories.delete_history(output_history_id)