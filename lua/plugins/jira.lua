return {
	{
		"letieu/jira.nvim",
		opts = {
			-- Your setup options...
			jira = {
				api_version = "2",
				limit = 200, -- Global limit of tasks per view (default: 200)
			},
			-- Saved JQL queries for the JQL tab
			-- Use %s as a placeholder for the project key
			queries = {
				["待发布"] = "project = '%s' AND issuetype != 子任务 AND 开发负责人 = currentUser() AND status in (准备发布, 测试完成, 待发布, 待上线) ORDER BY issuekey DESC",
				["测试中"] = "project = '%s' AND issuetype != 子任务 AND 开发负责人 = currentUser() AND status in (测试阶段, 等待测试) ORDER BY issuekey DESC",
				["研发中"] = "project = '%s' AND issuetype != 子任务 AND 开发负责人 = currentUser() AND status in (研发阶段) ORDER BY issuekey DESC",
				["All issues"] = "project = '%s' AND 开发负责人 = currentUser() ORDER BY issuekey DESC",
				["My Tasks"] = "assignee = currentUser() AND statusCategory != Done ORDER BY updated DESC",
				-- ["Next sprint"] = "project = '%s' AND sprint in futureSprints() ORDER BY Rank ASC",
				-- ["Backlog"] = "project = '%s' AND (issuetype IN standardIssueTypes() OR issuetype = Sub-task) AND (sprint IS EMPTY OR sprint NOT IN openSprints()) AND statusCategory != Done ORDER BY Rank ASC",
			},
		},
	},
}
