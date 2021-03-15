class Xxh < Formula
  include Language::Python::Virtualenv

  desc "Bring your favorite shell wherever you go through the ssh"
  homepage "https://github.com/xxh/xxh"
  url "https://files.pythonhosted.org/packages/2d/71/3fbc4861cc5dbf9bdc0515aa98526fe1dfd0d666a90252a43f922f74a174/xxh-xxh-0.8.7.tar.gz"
  sha256 "3608144e2035b7d3a8a24873b3dd74ea1b4460892971e265506fd46274ad2973"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0754a6da98349c722996e01826f2a241a2e4f6018d598681cb09e5eb63556616"
    sha256 cellar: :any_skip_relocation, big_sur:       "4befe7495d9545c742ffa02ec74391ca18ae98ad2e33c325d1d5fa1e78934498"
    sha256 cellar: :any_skip_relocation, catalina:      "7fde18469744ddf9ac4d92cbf864dd5aa4019b5e58ed796cb5d23a11c8d6e0b8"
    sha256 cellar: :any_skip_relocation, mojave:        "3b122613ebc9631201b902b99b26810c02c2b51084e70242c2fce6b55c7b8fd3"
    sha256 cellar: :any_skip_relocation, high_sierra:   "a01521553c7ee0f9c143e9c58f95233d9b0d497fbc08ccef90c11c0a60412a10"
  end

  depends_on "python@3.9"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xxh --version")

    (testpath/"config.xxhc").write <<~EOS
      hosts:
        test.localhost:
          -o: HostName=127.0.0.1
          +s: xxh-shell-zsh
    EOS
    begin
      port = free_port
      server = TCPServer.new(port)
      server_pid = fork do
        msg = server.accept.gets
        server.close
        assert_match "SSH", msg
      end

      stdout, stderr, = Open3.capture3(
        "#{bin}/xxh", "test.localhost",
        "-p", port.to_s,
        "+xc", "#{testpath}/config.xxhc",
        "+v"
      )

      argv = stdout.lines.grep(/^Final arguments list:/).first.split(":").second
      args = JSON.parse argv.tr("'", "\"")
      assert_include args, "xxh-shell-zsh"

      ssh_argv = stderr.lines.grep(/^ssh arguments:/).first.split(":").second
      ssh_args = JSON.parse ssh_argv.tr("'", "\"")
      assert_include ssh_args, "Port=#{port}"
      assert_include ssh_args, "HostName=127.0.0.1"
      assert_match "Connection closed by remote host", stderr
    ensure
      Process.kill("TERM", server_pid)
    end
  end
end
