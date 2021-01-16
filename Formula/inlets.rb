class Inlets < Formula
  desc "Expose your local endpoints to the Internet"
  homepage "https://github.com/inlets/inlets"
  url "https://github.com/inlets/inlets.git",
      tag:      "2.7.10",
      revision: "9bbbd0ef498474b922830bd2bfaa6a1caf382660"
  license "MIT"
  head "https://github.com/inlets/inlets.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a109f03f644398c4f63a527e14cdfd62fa766566f98503efb79518d06baeaf86" => :big_sur
    sha256 "b0313990e00dcba9f9cf6781966cf7dd73c4f7f7555b83581b402ac0ab064604" => :arm64_big_sur
    sha256 "cabff941d6c28e6e5fba7408862c3ad9b9dc8cce3400cfc2c3842ef78f2aa04e" => :catalina
    sha256 "b4fbf74800a0d0baeac891755ac892817c4ec32e851d27fda613fce56918503c" => :mojave
    sha256 "76c5394f14c87b319df9a06dd097edfacc0bb040ac7273de8cfa2cfa07408830" => :high_sierra
  end

  depends_on "go" => :build

  uses_from_macos "ruby" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.GitCommit=#{Utils.git_head}
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "-a", "-installsuffix", "cgo"
  end

  def cleanup(name, pid)
    puts "Tearing down #{name} on PID #{pid}"
    Process.kill("TERM", pid)
    Process.wait(pid)
  end

  test do
    upstream_port = free_port
    remote_port = free_port
    mock_response = "INLETS OK".freeze
    secret_token = "itsasecret-sssshhhhh".freeze

    (testpath/"mock_upstream_server.rb").write <<~EOS
      require 'socket'
      server = TCPServer.new('localhost', #{upstream_port})
      loop do
        socket = server.accept
        request = socket.gets
        STDERR.puts request
        response = "OK\\n"
        shutdown = false
        if request.include? "inlets-test"
          response = "#{mock_response}\\n"
          shutdown = true
        end
        socket.print "HTTP/1.1 200 OK\\r\\n" +
                    "Host: localhost:#{upstream_port}\\r\\n" +
                    "Content-Type: text/plain\\r\\n" +
                    "Content-Length: \#\{response.bytesize\}\\r\\n" +
                    "Connection: close\\r\\n"
        socket.print "\\r\\n"
        socket.print response
        socket.close
        if shutdown
          puts "Exiting test server"
          exit 0
        end
      end
    EOS

    mock_upstream_server_pid = fork do
      exec "ruby mock_upstream_server.rb"
    end

    begin
      # Basic --version test
      commit_regex = /[a-f0-9]{40}/
      inlets_version = shell_output("#{bin}/inlets version")
      assert_match commit_regex, inlets_version
      assert_match version.to_s, inlets_version

      # Client/Server e2e test
      # This test involves establishing a client-server inlets tunnel on the
      # remote_port, running a mock server on the upstream_port and then
      # testing that we can hit the mock server upstream_port via the tunnel remote_port
      sleep 3 # Waiting for mock server
      server_pid = fork do
        exec "#{bin}/inlets server --port #{remote_port} --token #{secret_token}"
      end

      client_pid = fork do
        # Starting inlets client
        exec "#{bin}/inlets client --remote localhost:#{remote_port} " \
             "--upstream localhost:#{upstream_port} --token #{secret_token}"
      end

      sleep 3 # Waiting for inlets websocket tunnel
      assert_match mock_response, shell_output("curl -s http://localhost:#{remote_port}/inlets-test")
    ensure
      cleanup("Mock Server", mock_upstream_server_pid)
      cleanup("Inlets Server", server_pid)
      cleanup("Inlets Client", client_pid)
    end
  end
end
