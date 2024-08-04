run_dev:
	mix phx.server

run_terminal:
	iex -S mix phx.server

fetch_dep:
	mix deps.get