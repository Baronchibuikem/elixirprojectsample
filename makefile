run_dev:
	mix phx.server

run_terminal:
	iex -S mix phx.server

install_dep:
	mix deps.get

clean-up:
	mix deps.clean --all

compile:
	mix compile