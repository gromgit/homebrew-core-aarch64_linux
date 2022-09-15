class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.21.0.tar.gz"
  sha256 "8816d8379321fd3160f57d771b4b743f04bab57dd1ec8d04def0b15a96bde87c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17fd9c4966aa6e7e66818c2b84bb847fd96636d19b2b296620b87d53e95997aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ceb388a0131227abf61a920bccd3f94d18ea0588ebe6c78f8d3a075ef4d5ffaf"
    sha256 cellar: :any_skip_relocation, monterey:       "30b12a3b9378c14f79e060b5f4f40c0ddeb38e69514f4c477b7358d0d9c8e1bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf56816ae95a90e252949756abaa2c118638e0ac74c45f08f7b9d8ce6b2d5601"
    sha256 cellar: :any_skip_relocation, catalina:       "ecdef3d7ecc8e0edb2de1be9c13cf3722ccb469c293069f3ec6a14ace1403125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "468d8fd3567d92eba025ddf900bb16965691b060e31505eeb5d2d10dcaee47d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
