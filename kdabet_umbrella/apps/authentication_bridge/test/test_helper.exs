# Bureaucrat.start(
#  writer: Bureaucrat.MarkdownWriter,
#  default_path: "docs/api-v1.md",
#  paths: [],
#  titles: [
#    {WalletController, "API /wallet"}
#  ],
#  env_var: "DOC"
# )
#
# titles add extra metadata to alias controllers
# add Bureaucrat formatter to ExUnit.start()
# ExUnit.start(formatters: [ExUnit.CLIFormatter, Bureaucrat.Formatter])
## Start the Reppos for the tests
AuthenticationBridge.start_repos()

ExUnit.start()
