start-release:
	test -n "$(jira_current_release_id)"  # argument "jira_current_release_id" is required
	$(eval new_version := $(shell bumpversion --dry-run --list minor | grep new_version | sed s,"^.*=",,))
	git checkout develop && git pull origin develop
	bumpversion minor
	echo $(jira_current_release_id) > .jira-current-release
	git add .jira-current-release .bumpversion.cfg VERSION
	git commit -m 'Start release: $(new_version)'
	git push origin develop
	git flow release start $(new_version)
	git flow release publish $(new_version)

start-hotfix:
	test -n "$(jira_current_release_id)"  # argument "jira_current_release_id" is required
	$(eval new_version := $(shell bumpversion --dry-run --list patch | grep new_version | sed s,"^.*=",,))
	git flow hotfix start $(new_version)
	bumpversion patch
	echo $(jira_current_release_id) > .jira-current-release
	git add .jira-current-release .bumpversion.cfg VERSION
	git commit -m 'Start hotfix: $(new_version)'

.PHONY: start-release start-hotfix
