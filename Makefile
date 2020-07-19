PROJECT_NAME='Trianon100'
AUTHOR=may.panni@gmail.com
DESCRIPTION='Trianon 100: geodata mappings'

include config.conf

requirements:
	bash -euo pipefail ./scripts/env_scripts/export_conda_environment.sh
	rm -f .conda_env_created

.conda_env_created: requirements.yml
	bash -euo pipefail ./scripts/env_scripts/create_conda_environment.sh
	mkdir -p data

.jupyter_kernel_registered: .conda_env_created
	bash -euo pipefail ./scripts/env_scripts/register_kernel.sh

.${NOTEBOOK_PATH}_cleaned: ${NOTEBOOK_PATH}
	bash -euo pipefail ./scripts/env_scripts/clean_notebook.sh ${NOTEBOOK_PATH}

.PHONY: setup
setup: .conda_env_created

.PHONY: jupyter
jupyter: .jupyter_kernel_registered

# to use this, first specify your notebook name in config.conf!
.PHONY: clean_notebook
clean_notebook: .${NOTEBOOK_PATH}_cleaned
